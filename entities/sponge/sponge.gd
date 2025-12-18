class_name Sponge
extends StaticBody2D

@export_category("Droplet Spawning")
@export var droplet_growth_rate: float = 1.0
@export var droplet_spawn_point: Marker2D
@export var collision_shape: CollisionShape2D
@export var droplet_sprite: Sprite2D
@export var droplet_scene: PackedScene

var droplet_growing: bool = false
var rect_shape: RectangleShape2D

func _ready() -> void:
	rect_shape = collision_shape.shape

func _process(delta: float) -> void:
	if not droplet_growing:
		droplet_spawn_point.position = get_random_point(rect_shape)
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

func get_random_point(shape: RectangleShape2D) -> Vector2:
	var extents = shape.extents

	var x: float = randf_range(-extents.x, extents.x)
	var y: float = randf_range(-extents.y, extents.y)

	return(Vector2(x, y))
