extends Area2D

@export var size_bonus: float = 5.0
@export var grow_component: GrowComponent

func _ready() -> void:
	grow_component.size = 16.0
	grow_component.update_size()

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return

	body = body as Player

	body.health_component.heal(size_bonus)

	queue_free()
