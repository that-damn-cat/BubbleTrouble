extends State

@export var death_anim: AnimatedSprite2D
@export var disable_nodes: Array[Node]

func enter() -> void:
	death_anim.connect("animation_finished", _on_animation_complete)

	for node in disable_nodes:
		if node.has_method("hide"):
			node.call_deferred("hide")

		if node.get("disabled") != null:
			node.set_deferred("disabled", true)

		if node.get("monitoring") != null:
			node.set_deferred("monitoring", false)

		if node.get("monitorable") != null:
			node.set_deferred("monitorable", false)

		if node.get("process_mode") != null:
			node.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

	death_anim.show()
	death_anim.play("default")

func _on_animation_complete() -> void:
	state_machine.controlled_node.queue_free()
