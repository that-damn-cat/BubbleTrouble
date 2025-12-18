extends State

@export var disable_nodes: Array[Node]
@export var sprite: AnimatedSprite2D
@export var dissolve_secs: float = 1.5

var shader: ShaderMaterial
var anim_tween: Tween

func enter() -> void:
	state_machine.controlled_node.set_death_shader()
	shader = sprite.material

	for node in disable_nodes:
		if node.has_method("hide"):
			node.call_deferred("hide")

		if node.get("disabled"):
			node.set_deferred("disabled", true)

		if node.get("monitoring"):
			node.set_deferred("monitoring", false)

		if node.get("monitorable"):
			node.set_deferred("monitorable", false)

		if node.get("process_mode"):
			node.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

	anim_tween = create_tween()
	anim_tween.tween_method(set_dissolve_progress, 0.0, 1.0, dissolve_secs)
	anim_tween.finished.connect(_on_dissolve_finished)

func _on_dissolve_finished() -> void:
	state_machine.controlled_node.queue_free()

func set_dissolve_progress(amount: float) -> void:
	shader.set_shader_parameter("progress", amount)