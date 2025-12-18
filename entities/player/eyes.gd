extends Sprite2D

@export var player: Player
@export var warmth_component: WarmthComponent
@export var player_state_machine: StateMachine
@export var eye_move_time: float = 0.7

@export_category("Eye Positions")
@export var center_position: Marker2D
@export var left_position: Marker2D
@export var up_position: Marker2D
@export var right_position: Marker2D
@export var down_position: Marker2D

var position_tween: Tween
var last_direction_binary := Vector2i.ZERO

func _process(_delta: float) -> void:
	frame = 0

	if warmth_component.is_frozen:
		frame = 1

	if player_state_machine.current_state == player_state_machine.get_state("splitting"):
		frame = 1

	var direction_binary: Vector2i = Vector2i.ZERO

	if abs(player.direction.x) >= 0.45:
		direction_binary.x = sign(player.direction.x)

	if abs(player.direction.y) >= 0.45:
		direction_binary.y = sign(player.direction.y)

	if direction_binary == last_direction_binary:
		return

	if position_tween:
		position_tween.kill()

	var target_position: Vector2 = _get_target_position(direction_binary)

	position_tween = create_tween()
	position_tween.tween_property(self, "position", target_position, eye_move_time)

	last_direction_binary = direction_binary

func _get_target_position(direction: Vector2i) -> Vector2:
	if direction == Vector2i.ZERO:
		return center_position.position

	var positions: Array[Vector2] = []

	if direction.x < 0:
		positions.append(left_position.position)
	if direction.x > 0:
		positions.append(right_position.position)

	if direction.y < 0:
		positions.append(up_position.position)
	if direction.y > 0:
		positions.append(down_position.position)

	if positions.size() == 1:
		return positions[0]

	var sum := Vector2.ZERO
	for entry in positions:
		sum += entry

	return sum / positions.size()
