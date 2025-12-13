extends State

var physics_delay_secs: float = 0.75
var elapsed_time: float = 0.0

func enter() -> void:
	elapsed_time = 0.0
	state_machine.controlled_node.set_collision_mask_value(2, false)
	state_machine.controlled_node.animation.play("shoot_spawn")

func update(delta: float) -> void:
	if elapsed_time <= physics_delay_secs:
		elapsed_time += delta
		return

	state_machine.controlled_node.set_collision_mask_value(2, true)
	transition_to("active")
