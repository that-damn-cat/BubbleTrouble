extends State

var germ: Germ
var target: Node2D

func enter() -> void:
	germ = state_machine.controlled_node
	target = state_machine.target_node

func update(_delta: float) -> void:
	if not target:
		transition_to("idle")
		return

	germ.target_speed = germ.seek_speed
	germ.direction = germ.global_position.direction_to(target.global_position)

func _on_seek_body_exited(body: Node2D) -> void:
	if state_machine.current_state != self:
		return

	if body == target:
		transition_to("idle")