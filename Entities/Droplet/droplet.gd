extends Area2D

@export var size_bonus: float = 5.0
@export var grow_component: GrowComponent

func _ready() -> void:
	grow_component.size = 16.0
	grow_component.update_size()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.set_mass(body.mass + size_bonus)
		queue_free()
