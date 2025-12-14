extends Area2D

@export var animation: AnimatedSprite2D
@export var health_component: HealthComponent

@export_category("Germ Spawning")
@export var germ_growth_rate: float = 10.0
@export var germ_spawn_point: Marker2D
@export var hurtbox_shape: CollisionPolygon2D
@export var germ_sprite: AnimatedSprite2D
@export var germ_scene: PackedScene

var germ_growing: bool = false

func _ready() -> void:
	health_component.current_health = health_component.max_health
	animation.play("default")
	animation.pause()

func update_sprite() -> void:
	if health_component.is_dead:
		animation.play("died")
		return

	animation.frame = int(health_component.max_health - health_component.current_health)

func _process(delta: float) -> void:
	if not germ_growing:
		germ_spawn_point.position = random_point_from_polygon(hurtbox_shape)
		germ_growing = true
		germ_sprite.visible = true

	germ_sprite.scale.x += germ_growth_rate * delta
	germ_sprite.scale.y += germ_growth_rate * delta

	if germ_sprite.scale.x >= 1.0:
		germ_growing = false
		germ_sprite.scale.x = 0.1
		germ_sprite.scale.y = 0.1
		germ_sprite.visible = false
		spawn_germ()

func spawn_germ() -> void:
	var new_germ = germ_scene.instantiate()
	new_germ.global_position = germ_spawn_point.global_position
	globals.enemy_container.add_child(new_germ)

func random_point_from_polygon(shape: CollisionPolygon2D) -> Vector2:
	var polygon = shape.polygon

	var triangle_points := Geometry2D.triangulate_polygon(polygon)

	@warning_ignore("integer_division")
	var triangle_count: int = triangle_points.size() / 3

	if triangle_count <= 0:
		push_error("No Triangles in Polygon!")
		return(Vector2.INF)

	var cumulated_triangle_areas: Array[float]
	cumulated_triangle_areas.resize(triangle_count)
	cumulated_triangle_areas[-1] = 0.0

	for i in range(triangle_count):
		var a: Vector2 = polygon[triangle_points[3 * i + 0]]
		var b: Vector2 = polygon[triangle_points[3 * i + 1]]
		var c: Vector2 = polygon[triangle_points[3 * i + 2]]
		cumulated_triangle_areas[i] = cumulated_triangle_areas[i - 1] + triangle_area(a, b, c)

	var total_area: float = cumulated_triangle_areas[-1]
	var choosen_triangle_index: int = cumulated_triangle_areas.bsearch(randf() * total_area)
	var chosen_a = polygon[triangle_points[3 * choosen_triangle_index + 0]]
	var chosen_b = polygon[triangle_points[3 * choosen_triangle_index + 1]]
	var chosen_c = polygon[triangle_points[3 * choosen_triangle_index + 2]]
	return random_triangle_point(chosen_a, chosen_b, chosen_c)

func triangle_area(a: Vector2, b: Vector2, c: Vector2) -> float:
	return 0.5 * abs((c.x - a.x) * (b.y - a.y) - (b.x - a.x) * (c.y - a.y))

func random_triangle_point(a: Vector2, b: Vector2, c: Vector2) -> Vector2:
	return a + sqrt(randf()) * (-a + b + randf() * (c - b))

func _on_damaged(_amount: float) -> void:
	update_sprite()

func _on_healed(_amount: float) -> void:
	update_sprite()

func _on_died() -> void:
	update_sprite()
	await animation.animation_finished
	queue_free()