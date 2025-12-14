extends StateMachine

@export var controlled_node: Player

func _on_player_died() -> void:
	change_state("dying")