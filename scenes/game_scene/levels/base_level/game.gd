class_name Level
extends Node

signal level_lost
signal level_won
signal level_won_and_changed(level_path : String)

## Optional path to the next level if using an open world level system.
@export_file("*.tscn") var next_level_path : String

@export var level_title: String

var level_state: LevelState
var fallback_respawn_position: Vector2
var player_scene: PackedScene

func _ready() -> void:
	if level_title == "":
		level_title = "MISSING LEVEL TITLE"

	setup_globals()

	if not player_scene:
		player_scene = preload("res://entities/player/player.tscn")

	fallback_respawn_position = globals.player_container.get_children()[0].global_position

	level_state = GameState.get_level_state(scene_file_path)
	if not level_state.tutorial_read:
		open_tutorials()

func _process(_delta: float) -> void:
	level_state = GameState.get_level_state(scene_file_path)

	if not globals.game_node \
		or not globals.player_container \
		or not globals.enemy_container \
		or not globals.pickup_container:
			setup_globals()

	var num_enemies: int = 0

	if globals.num_lives <= 0:
		reset_game_data()
		level_lost.emit()
		globals.num_lives = 3
		return

	for child in globals.enemy_container.get_children():
		if child is Germ or child is Dirt or child is WoeCube:
			num_enemies += 1

	if num_enemies == 0:
		if not next_level_path.is_empty():
			level_won_and_changed.emit(next_level_path)
		else:
			level_won.emit()

		reset_game_data()
		return

	var num_players: int = 0

	for child in globals.player_container.get_children():
		if child is Player:
			num_players += 1

	if num_players == 0:
		globals.num_lives -= 1
		if globals.num_lives <= 0:
			return

		print(globals.num_lives)

		var new_player: Player = player_scene.instantiate()
		new_player.global_position = get_respawn_position()
		globals.player_container.add_child(new_player)

func reset_game_data() -> void:
	globals.game_node = null
	globals.player_container = null
	globals.enemy_container = null
	globals.pickup_container = null
	globals.level_title = ""

func setup_globals() -> void:
	globals.game_node = self
	globals.player_container = %Players
	globals.enemy_container = %Enemies
	globals.pickup_container = %Pickups
	globals.level_title = level_title

func get_respawn_position() -> Vector2:
	var largest_droplet: Droplet = null

	for droplet in globals.pickup_container.get_children():
		if droplet is not Droplet:
			continue

		if not largest_droplet:
			largest_droplet = droplet

		if droplet.size_bonus > largest_droplet.size_bonus:
			largest_droplet = droplet

	if not largest_droplet:
		return(fallback_respawn_position)

	largest_droplet.queue_free()
	return(largest_droplet.global_position)

func open_tutorials() -> void:
	%TutorialManager.open_tutorials()
	level_state.tutorial_read = true
	GlobalState.save()

func _on_tutorial_button_pressed() -> void:
	open_tutorials()