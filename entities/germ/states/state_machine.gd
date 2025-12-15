extends StateMachine

@export var controlled_node: Germ
@export var target_node: Node2D

func _on_germ_died() -> void:
	change_state("dying")