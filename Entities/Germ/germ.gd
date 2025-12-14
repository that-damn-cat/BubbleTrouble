class_name Germ
extends CharacterBody2D

@export var acceleration: float = 3.0
@export var idle_speed: float = 50.0
@export var seek_speed: float = 175.0

var direction := Vector2.ZERO
var target_speed: float = idle_speed

func _physics_process(_delta: float) -> void:
	velocity += direction * acceleration

	if velocity.length() > target_speed:
		velocity = lerp(velocity, direction * target_speed, 0.04)

	move_and_slide()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	body.queue_free()
	queue_free()
