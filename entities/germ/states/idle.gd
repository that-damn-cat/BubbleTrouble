extends State

var germ: Germ

func enter() -> void:
	germ = state_machine.controlled_node

## To be implemented by the inheriting node. Called with _process
func update(_delta: float) -> void:
	germ.target_speed = germ.idle_speed
	germ.direction += Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	germ.direction = germ.direction.normalized()

func _on_seek_body_entered(body: Node2D) -> void:
	if state_machine.current_state != self:
		return

	if body is Player:
		state_machine.target_node = body
		transition_to("seek")