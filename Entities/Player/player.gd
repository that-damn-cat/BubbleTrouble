class_name Player
extends CharacterBody2D

signal died

@export_category("Components")
@export var grow_component: GrowComponent

@export_category("Visuals")
@export var animation: AnimationPlayer

@export_category("Mass")
@export var mass: float = 20.0
@export var min_mass: float = 10.0
@export var max_mass: float = 50.0
@export var shot_mass: float = 10.0

@export_category("Motion")
@export var max_acceleration: float = 25.0
@export var min_acceleration: float = 5.0
@export var min_speed: float = 175.0
@export var max_speed: float = 550.0
@export_range(0.0, 1.0, 0.01) var friction = .09

@export_category("Collider Settings")
@export var collider: CollisionShape2D
@export var merge_collder: CollisionShape2D

var direction := Vector2.ZERO

func _ready() -> void:
	collider.shape = CircleShape2D.new()
	merge_collder.shape = CircleShape2D.new()
	set_mass(mass)

func set_mass(amount: float) -> void:
	mass = clamp(amount, 0, max_mass)
	grow_component.size = mass
	grow_component.update_size()

	%MassLabel.position.y = -(mass + 32.0)
	%MassLabel.text = "Mass: %0.1f" % mass

	if mass < min_mass:
		died.emit()

func merge(consumed: Player) -> void:
	set_mass(mass + consumed.mass)
	consumed.queue_free()

func _physics_process(delta):
	var acceleration = remap(mass, min_mass, max_mass, max_acceleration, min_acceleration)
	var speed_cap = remap(mass, min_mass, max_mass, max_speed, min_speed)

	if direction.length() > 0.0:
		velocity += direction * acceleration
		velocity = velocity.limit_length(speed_cap)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)

	move_and_slide()

func _on_merge_area_body_entered(body: Node2D) -> void:
	if body is not Player:
		return

	if body == self:
		return

	body = body as Player

	if mass < body.mass:
		return

	merge(body)
