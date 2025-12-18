class_name GrowComponent
extends Node

@export_category("Collections")
@export var sprites: Array[Sprite2D]
@export var nodes: Array[Node2D]
@export var collision_offsets: Dictionary[CollisionShape2D, float]

@export_category("Size Factors")
@export var size: float
@export var scaling: float = 1.0
@export var sprite_size_modifier: float = 1.0

var initial_size: float

func update_size() -> void:
	if initial_size <= 0.0:
		initial_size = size

	for sprite in sprites:
		if not is_instance_valid(sprite) or sprite.texture == null:
			continue

		var sprite_width = sprite.texture.get_size().x / sprite.hframes
		sprite.scale.x = (size / sprite_width) * globals.scaling_factor * scaling * sprite_size_modifier
		sprite.scale.y = sprite.scale.x
		#var sprite_height = sprite.texture.get_size().y / sprite.vframes
		#sprite.scale.y = (size / sprite_height) * globals.scaling_factor * scaling * sprite_size_modifier

	for node in nodes:
		node.scale = Vector2((size / initial_size), (size / initial_size))

	for collider in collision_offsets.keys():
		if not is_instance_valid(collider):
			continue

		var shape: Shape2D = collider.shape

		if shape is CircleShape2D:
			var target_radius = ((size / 2.0) + collision_offsets[collider]) * globals.scaling_factor * scaling
			target_radius = max(1.0, target_radius)
			shape.radius = target_radius
		else:
			push_error("Shape type not handled yet. Implement me :(")

func add_size(amount: float) -> void:
	size += amount
	update_size()

func mult_size(amount: float) -> void:
	size *= amount
	update_size()
