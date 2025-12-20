class_name Sponge
extends StaticBody2D

@export_category("Droplet Spawning")
@export var droplet_growth_rate: float = 1.0
@export var droplet_spawn_point: Marker2D
@export var spawn_shape: CollisionPolygon2D
@export var droplet_sprite: Sprite2D
@export var droplet_scene: PackedScene

var droplet_growing: bool = false
var rect_shape: RectangleShape2D

func _process(delta: float) -> void:
	if not droplet_growing:
		droplet_spawn_point.position = random_point_from_polygon(spawn_shape)
		droplet_growing = true
		droplet_sprite.visible = true

	droplet_sprite.scale.x += droplet_growth_rate * delta
	droplet_sprite.scale.y += droplet_growth_rate * delta

	if droplet_sprite.scale.x >= 1.0:
		droplet_growing = false
		droplet_sprite.scale.x = 0.1
		droplet_sprite.scale.y = 0.1
		droplet_sprite.visible = false
		spawn_droplet()

func spawn_droplet() -> void:
	if not globals.data_filled:
		return

	var new_droplet = droplet_scene.instantiate()
	new_droplet.global_position = droplet_spawn_point.global_position

	if not globals.pickup_container:
		return

	globals.pickup_container.add_child(new_droplet)

func random_point_from_polygon(shape: CollisionPolygon2D) -> Vector2:
	var polygon = shape.polygon

	var triangle_points := Geometry2D.triangulate_polygon(polygon)

	@warning_ignore("integer_division")
	var triangle_count: int = triangle_points.size() / 3

	if triangle_count <= 0:
		push_error("No Triangles in Polygon!")
		return(Vector2.INF)

	var triangle_area_sums: Array[float]
	triangle_area_sums.resize(triangle_count)
	triangle_area_sums[-1] = 0.0

	for i in range(triangle_count):
		var a: Vector2 = polygon[triangle_points[3 * i + 0]]
		var b: Vector2 = polygon[triangle_points[3 * i + 1]]
		var c: Vector2 = polygon[triangle_points[3 * i + 2]]
		triangle_area_sums[i] = triangle_area_sums[i - 1] + triangle_area(a, b, c)

	var total_area: float = triangle_area_sums[-1]
	var choosen_triangle_index: int = triangle_area_sums.bsearch(randf() * total_area)
	var chosen_a = polygon[triangle_points[3 * choosen_triangle_index + 0]]
	var chosen_b = polygon[triangle_points[3 * choosen_triangle_index + 1]]
	var chosen_c = polygon[triangle_points[3 * choosen_triangle_index + 2]]
	return random_triangle_point(chosen_a, chosen_b, chosen_c)

func triangle_area(a: Vector2, b: Vector2, c: Vector2) -> float:
	return 0.5 * abs((c.x - a.x) * (b.y - a.y) - (b.x - a.x) * (c.y - a.y))

func random_triangle_point(a: Vector2, b: Vector2, c: Vector2) -> Vector2:
	return a + sqrt(randf()) * (-a + b + randf() * (c - b))