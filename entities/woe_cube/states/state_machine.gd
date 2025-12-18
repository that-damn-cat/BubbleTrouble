extends StateMachine

@export var controlled_node: WoeCube

func _on_woe_cube_dying() -> void:
	change_state("dying")