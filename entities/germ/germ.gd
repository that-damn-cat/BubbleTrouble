class_name Germ
extends CharacterBody2D

@export var acceleration: float = 3.0
@export var idle_speed: float = 50.0
@export var seek_speed: float = 175.0
@export var health_component: HealthComponent
@export var warmth_component: WarmthComponent
@export var sprite: AnimatedSprite2D

@onready var death_shader: Shader = preload("res://shaders/pixel_dissolve_flash.gdshader")
@onready var freeze_shader: Shader = preload("res://shaders/frost.gdshader")

var direction := Vector2.ZERO
var target_speed: float = idle_speed

var freeze_sources: Array[WoeCube] = []

func _ready() -> void:
	health_component.current_health = health_component.max_health
	set_freeze_shader()

func _process(delta: float) -> void:
	clean_array(freeze_sources)
	var total_freeze_rate: float = 0.0

	for source in freeze_sources:
		total_freeze_rate += source.freeze_rate

	warmth_component.value -= total_freeze_rate * delta

func _physics_process(_delta: float) -> void:
	velocity += direction * acceleration

	if velocity.length() > target_speed:
		velocity = lerp(velocity, direction * target_speed, 0.04)

	move_and_slide()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Droplet:
		body.queue_free()

func clean_array(arr: Array) -> void:
	var to_remove: Array[int] = []

	for index in range(arr.size()):
		if arr[index] == null or not is_instance_valid(arr[index]):
			to_remove.append(index)

	for index in to_remove:
		if index < arr.size():
			arr.remove_at(index)

func set_freeze_shader() -> void:
	sprite.material.shader = freeze_shader

func set_death_shader() -> void:
	sprite.material.shader = death_shader
