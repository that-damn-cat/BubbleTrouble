extends State

var controlled_node: Player

func enter() -> void:
	controlled_node = state_machine.controlled_node
	controlled_node.animation.play("split")

	var new_player : Player = controlled_node.duplicate()
	controlled_node.velocity *= Vector2(-1, -1)
	new_player.velocity *= 2.0
	controlled_node.velocity *= 0.8

	new_player.mass *= 0.5
	controlled_node.set_mass(controlled_node.mass * 0.5)
	controlled_node.set_collision_mask_value(2, false)

	globals.player_container.add_child(new_player)

func update(_delta: float) -> void:
	pass
	#state_machine.controlled_node.direction = Input.get_vector("left", "right", "up", "down")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "split":
		transition_to("active")
