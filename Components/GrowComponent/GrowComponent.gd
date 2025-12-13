class_name GrowComponent
extends Node

@export var sprites: Array[Sprite2D]
@export var collision_shapes: Array[CollisionShape2D]
@export var collider_inset_px: float
@export var size: float
@export var scaling: float = 1.0

func _ready() -> void:
	update_size()

func update_size() -> void:
	for sprite in sprites:
		var sprite_width = sprite.texture.get_size().x / sprite.hframes
		sprite.scale.x = (size / sprite_width) * globals.scaling_factor * scaling

		var sprite_height = sprite.texture.get_size().y / sprite.vframes
		sprite.scale.y = (size / sprite_height) * globals.scaling_factor * scaling

	for collider in collision_shapes:
		var shape: Shape2D = collider.shape

		if shape is CircleShape2D:
			shape.radius = ((size / 2.0) - collider_inset_px) * globals.scaling_factor * scaling
		else:
			push_error("Shape type not handled yet. Implement me :(")

func add_size(amount: float) -> void:
	size += amount
	update_size()

func mult_size(amount: float) -> void:
	size *= amount
	update_size()