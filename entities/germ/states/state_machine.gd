extends StateMachine

@export var controlled_node: Germ
@export var target_node: Node2D

func _on_germ_died() -> void:
	change_state("dying")

func _on_warmth_component_froze() -> void:
	if current_state != get_state("dying"):
		change_state("frozen")

func _on_warmth_component_thawed() -> void:
	if current_state != get_state("dying"):
		change_state("idle")
