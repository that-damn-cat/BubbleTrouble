class_name WoeCube
extends CharacterBody2D

@export var melt_rate: float = 0.6
@export var health_component: HealthComponent
@export var sprite: Sprite2D

signal dying

func _ready() -> void:
	health_component.current_health = health_component.max_health

func _process(delta):
	health_component.current_health -= melt_rate * delta
	var target_frame = int(health_component.max_health) - ceil(health_component.current_health)

	if target_frame > 4:
		dying.emit()
		return

	sprite.frame = target_frame
