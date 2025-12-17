extends Area2D

@export var drain: Drain

func _on_area_entered(area: Area2D) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Germ or body is Dirt or body is Droplet:
		body.queue_free()
		return

	if body is Player:
		drain.draining_players.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		drain.draining_players.erase(body)