extends State

@export_file_path("*.tscn") var player_scene_path: String

var controlled_node: Player

func enter() -> void:
	controlled_node = state_machine.controlled_node
	controlled_node.animation.play("split")

func split() -> void:
	controlled_node.merge_collder.disabled = true
	var player_resource := load(player_scene_path) as PackedScene
	var new_player = player_resource.instantiate()
	new_player.global_position = controlled_node.global_position

	new_player.mass = controlled_node.shot_mass
	controlled_node.set_mass(controlled_node.mass - controlled_node.shot_mass)

	var min_effective_speed = 0.6 * controlled_node.min_speed
	if controlled_node.velocity.length() < min_effective_speed:
		var direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		controlled_node.velocity = direction * min_effective_speed

	new_player.velocity = controlled_node.velocity * 2.1
	controlled_node.velocity *= Vector2(-1, -1)
	controlled_node.velocity *= 0.8


	controlled_node.set_collision_mask_value(2, false)

	globals.player_container.add_child(new_player)

func update(_delta: float) -> void:
	pass
	#state_machine.controlled_node.direction = Input.get_vector("left", "right", "up", "down")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "split":
		controlled_node.merge_collder.disabled = false
		transition_to("active")
