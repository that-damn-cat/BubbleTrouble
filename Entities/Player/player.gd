class_name Player
extends CharacterBody2D

@export_category("Components")
@export var grow_component: GrowComponent

@export_category("Visual")
@export var grow_anim_mult: float = 1.0

@export_category("Physics")
@export var acceleration = 15
@export var max_speed = 500
@export_range(0.0, 1.0, 0.01) var friction = .09
@export var mass: float = 32.0

@export_category("Collider Settings")
@export var physics_inset_pixels: float = 2.0
@export var merge_outset_pixels: float = 1.0

var direction := Vector2.ZERO

func _ready() -> void:
	grow_component.size = mass
	grow_component.update_size()


func _process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	grow_component.scaling = grow_anim_mult
	grow_component.update_size()


func _physics_process(delta):
	if direction.length() > 0.0:
		velocity += direction * acceleration
		velocity = velocity.limit_length(max_speed)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)

	move_and_slide()