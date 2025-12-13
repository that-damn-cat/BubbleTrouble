class_name Player
extends CharacterBody2D

@export_category("Physics")
@export var acceleration = 15
@export var max_speed = 500
@export_range(0.0, 1.0, 0.01) var friction = .09
@export var mass: float = 32.0

@export_category("Collider Settings")
@export var physics_inset_pixels: float = 2.0
@export var merge_outset_pixels: float = 1.0


var direction := Vector2.ZERO
var sprite: Sprite2D
var collider: CollisionShape2D
var collision_shape: CircleShape2D

func _ready() -> void:
	sprite = %Bubs
	collider = %PhysicsCollider
	collision_shape = collider.shape

	update_size()


func _process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")


func _physics_process(delta):
	if direction.length() > 0.0:
		velocity += direction * acceleration
		velocity = velocity.limit_length(max_speed)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)

	move_and_slide()

func add_size(amount: float) -> void:
	mass += amount
	update_size()

func update_size() -> void:
	sprite.scale.x = mass / sprite.texture.get_size().x
	sprite.scale.y = mass / sprite.texture.get_size().y
	collision_shape.radius = (mass / 2.0) - physics_inset_pixels