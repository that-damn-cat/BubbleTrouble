extends Area2D

@export var size_bonus: float = 0.25

func _process(delta: float) -> void:
	pass

func _on_collision_shape_2d_child_entered_tree(node: Node) -> void:
	sizeup.emit()
	queue_free()
