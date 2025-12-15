extends Area2D

func _on_area_entered(area: Area2D) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player or body is Germ or body is Dirt or body is Droplet:
		body.queue_free()
