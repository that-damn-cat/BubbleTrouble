extends State

func enter() -> void:
	state_machine.controlled_node.queue_free()