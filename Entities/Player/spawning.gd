extends State

var physics_delay_secs: float = 0.75
var elapsed_time: float = 0.0
var controlled_node: Player

func enter() -> void:
	controlled_node = state_machine.controlled_node
	elapsed_time = 0.0

	controlled_node.set_collision_mask_value(2, false)
	controlled_node.merge_collder.disabled = true

	controlled_node.animation.play("shoot_spawn")

func update(delta: float) -> void:
	if elapsed_time <= physics_delay_secs:
		elapsed_time += delta
		return

	controlled_node.set_collision_mask_value(2, true)
	controlled_node.merge_collder.disabled = false
	transition_to("active")
