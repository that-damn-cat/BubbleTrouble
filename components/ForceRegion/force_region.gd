class_name ForceRegion
extends Area2D

enum Direction {UP, DOWN, LEFT, RIGHT}
@export var push_direction: Direction = Direction.DOWN
@export var min_push_force: float = 10.0
@export var max_push_force: float = 200.0

var body_entry_points: Dictionary[PhysicsBody2D, float] = {}
var max_size: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	var collision_shape = find_children("*", "CollisionShape2D", false)[0]
	var shape = collision_shape.shape

	if shape is RectangleShape2D:
		match push_direction:
			Direction.DOWN, Direction.UP:
				max_size = shape.size.y
			Direction.LEFT, Direction.RIGHT:
				max_size = shape.size.x
	else:
		push_error("Shape type not yet supported by force region")
		queue_free()

func _on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		match push_direction:
			Direction.DOWN, Direction.UP:
				body_entry_points[body as CharacterBody2D] = body.global_position.y
			Direction.LEFT, Direction.RIGHT:
				body_entry_points[body as CharacterBody2D] = body.global_position.x

func _on_body_exited(body: Node2D):
	if body is CharacterBody2D:
		body_entry_points.erase(body)

func _physics_process(_delta: float) -> void:
	for body in body_entry_points.keys():
		var distance_overshoot: float = 0.0

		match push_direction:
			Direction.DOWN, Direction.UP:
				distance_overshoot = abs(body.global_position.y - body_entry_points[body])
			Direction.LEFT, Direction.RIGHT:
				distance_overshoot = abs(body.global_position.x - body_entry_points[body])

		var push_force = remap(distance_overshoot, 0.0, max_size, min_push_force, max_push_force)

		var force_direction = Vector2.ZERO
		match push_direction:
			Direction.DOWN:
				force_direction = Vector2.DOWN
			Direction.UP:
				force_direction = Vector2.UP
			Direction.LEFT:
				force_direction = Vector2.LEFT
			Direction.RIGHT:
				force_direction = Vector2.RIGHT

		body.velocity += force_direction * push_force

func clean_array(arr: Array) -> void:
	var to_remove: Array[int] = []

	for index in range(arr.size()):
		if arr[index] == null:
			to_remove.append(index)

	for index in to_remove:
		arr.remove_at(index)