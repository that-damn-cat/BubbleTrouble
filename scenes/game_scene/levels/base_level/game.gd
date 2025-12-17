class_name Level
extends Node

signal level_lost
signal level_won
signal level_won_and_changed(level_path : String)

## Optional path to the next level if using an open world level system.
@export_file("*.tscn") var next_level_path : String

var level_state : LevelState

func _ready() -> void:
	setup_globals()

func _process(_delta: float) -> void:
	level_state = GameState.get_level_state(scene_file_path)

	if not globals.game_node \
		or not globals.player_container \
		or not globals.enemy_container \
		or not globals.pickup_container:
			setup_globals()

	var num_enemies: int = 0

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
		reset_game_data()
		level_lost.emit()

func reset_game_data() -> void:
	globals.game_node = null
	globals.player_container = null
	globals.enemy_container = null
	globals.pickup_container = null

func setup_globals() -> void:
	globals.game_node = self
	globals.player_container = %Players
	globals.enemy_container = %Enemies
	globals.pickup_container = %Pickups
