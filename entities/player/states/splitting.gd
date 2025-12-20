extends State

@export_file_path("*.tscn") var player_scene_path: String
@export var merge_collider: CollisionShape2D

var controlled_node: Player
var audio_start_jitter := Vector2(0.05, 0.15)

var sfx_delay_elapsed: float = 0.0
var sfx_delay_time: float = 0.0
var sfx_waiting: bool = false

func enter() -> void:
	merge_collider.set_deferred("disabled", true)
	controlled_node = state_machine.controlled_node
	controlled_node.animation.play("split")
	%SFX_Start.wait_time = randf_range(audio_start_jitter.x, audio_start_jitter.y)
	%SFX_Start.start()

func update(delta: float) -> void:
	if sfx_delay_elapsed >= sfx_delay_time and sfx_waiting:
		%Split.play()
		sfx_waiting = false

	sfx_delay_time += delta

	if state_machine.controlled_node.warmth_component.is_frozen:
		state_machine.controlled_node.direction = Vector2.ZERO
		return

	state_machine.controlled_node.direction = Input.get_vector("left", "right", "up", "down")

func exit() -> void:
	merge_collider.set_deferred("disabled", false)

func split() -> void:
	if not merge_collider:
		return

	if not controlled_node:
		return

	if not globals.data_filled:
		return

	if not globals.player_container:
		return

	var player_resource := load(player_scene_path) as PackedScene
	var new_player = player_resource.instantiate()
	new_player.global_position = controlled_node.global_position

	new_player.mass = controlled_node.shot_mass
	new_player.warmth_component.value = controlled_node.warmth_component.value
	controlled_node.health_component.damage(controlled_node.shot_mass)

	var min_effective_speed = 0.7 * controlled_node.min_speed
	if controlled_node.velocity.length() < min_effective_speed:
		var direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		controlled_node.velocity = 1.25 * direction * min_effective_speed

	new_player.velocity = controlled_node.velocity * 2.1
	controlled_node.velocity *= Vector2(-1, -1)
	controlled_node.velocity *= 0.8

	controlled_node.set_collision_mask_value(2, false)

	globals.player_container.add_child(new_player)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if not state_machine.current_state == self:
		return

	if anim_name == "split":
		transition_to("active")
