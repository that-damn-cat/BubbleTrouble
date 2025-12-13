extends State

func update(_delta: float) -> void:
	state_machine.controlled_node.direction = Input.get_vector("left", "right", "up", "down")

	if Input.is_action_just_pressed("shoot"):
		if (state_machine.controlled_node.mass * 0.5) < 10.0:
			return
		transition_to("splitting")

func exit() -> void:
	state_machine.controlled_node.direction = Vector2.ZERO