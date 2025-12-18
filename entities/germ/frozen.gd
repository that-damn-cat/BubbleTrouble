extends State

func enter() -> void:
	state_machine.controlled_node.set_freeze_shader()
	state_machine.controlled_node.direction = Vector2.ZERO
	state_machine.controlled_node.sprite.material.set_shader_parameter("enabled", true)

func exit() -> void:
	state_machine.controlled_node.sprite.material.set_shader_parameter("enabled", false)
