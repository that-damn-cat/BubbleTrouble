extends CharacterBody2D

@export_category("Speed Vars")
@export var acceleration = 15
@export var maxSpeed = 500
@export_range(0.0, 1.0, 0.01) var friction = .09

@export_category("Size Vars")
@export var bubsize = .1
@export var colisionSize = 16.0

signal seen

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if input_vector != Vector2.ZERO:
		velocity.normalized()
		velocity += input_vector * acceleration
		velocity = velocity.limit_length(maxSpeed)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)

	move_and_slide()


func _on_droplet_sizeup() -> void:
	%bubs.scale.x += bubsize
	%bubs.scale.y += bubsize
	%Size.shape.radius = %bubs.scale.x * colisionSize
