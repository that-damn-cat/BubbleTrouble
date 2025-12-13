class_name Player
extends CharacterBody2D

@export_category("Components")
@export var grow_component: GrowComponent

@export_category("Visuals")
@export var animation: AnimationPlayer

@export_category("Physics")
@export var acceleration = 15
@export var max_speed = 500
@export_range(0.0, 1.0, 0.01) var friction = .09
@export var mass: float = 20.0

@export_category("Collider Settings")
@export var collider: CollisionShape2D
@export var physics_inset_pixels: float = 2.0
@export var merge_outset_pixels: float = 1.0

var direction := Vector2.ZERO

func _ready() -> void:
	set_mass(mass)


func set_mass(amount: float) -> void:
	mass = amount
	grow_component.size = mass
	grow_component.update_size()
	%MassLabel.text = "Mass: %0.1f" % mass


func _physics_process(delta):
	if direction.length() > 0.0:
		velocity += direction * acceleration
		velocity = velocity.limit_length(max_speed)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)

	move_and_slide()