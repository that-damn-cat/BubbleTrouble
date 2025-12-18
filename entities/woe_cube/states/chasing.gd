extends State

var controlled_node: WoeCube

func enter() -> void:
	controlled_node = state_machine.controlled_node

func update(_delta: float) -> void:
	if not controlled_node.chase_target:
		controlled_node.direction = controlled_node.velocity.normalized()

		if controlled_node.direction == Vector2.ZERO:
			controlled_node.direction = Vector2(randf(), randf()).normalized()

		return

	controlled_node.direction = controlled_node.global_position.direction_to(controlled_node.chase_target.global_position)