extends Area2D

signal sizeup

func _process(delta: float) -> void:
	pass

func _on_collision_shape_2d_child_entered_tree(node: Node) -> void:
	sizeup.emit()
	queue_free()
