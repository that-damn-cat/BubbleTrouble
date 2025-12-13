extends Area2D

@export var size_bonus: float = 2.0

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.add_size(size_bonus)