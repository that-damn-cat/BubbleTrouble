extends State

func enter() -> void:
	state_machine.controlled_node.animation.play("idle")

func update(_delta: float) -> void:
	if state_machine.controlled_node.warmth_component.is_frozen:
		state_machine.controlled_node.direction = Vector2.ZERO
		return

	state_machine.controlled_node.direction = Input.get_vector("left", "right", "up", "down")

	if Input.is_action_just_pressed("shoot"):
		try_split()

func try_split() -> void:
	if not state_machine.current_state == self:
		return

	if state_machine.controlled_node.mass >= (state_machine.controlled_node.shot_mass * 2.0):
		transition_to("splitting")

func exit() -> void:
	state_machine.controlled_node.direction = Vector2.ZERO