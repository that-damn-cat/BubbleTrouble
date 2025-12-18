class_name WoeCube
extends CharacterBody2D

@export var chase_target: Node2D
@export var melt_rate: float = 0.5
@export var freeze_rate: float = 1.0
@export var chase_speed: float = 300.0
@export var chase_acceleration: float = 2.0
@export var health_component: HealthComponent
@export var sprite: Sprite2D

signal dying

var chase_target_type: String
var direction: Vector2

func _ready() -> void:
	health_component.current_health = health_component.max_health

	if not chase_target:
		chase_target_type = ""
		return

	if chase_target:
		var script = chase_target.get_script()
		if script:
			chase_target_type = chase_target.get_script().get_global_name()

	if chase_target_type.is_empty():
		chase_target_type = chase_target.get_class()

func _process(delta):
	health_component.current_health -= melt_rate * delta
	var target_frame = int(health_component.max_health) - ceil(health_component.current_health)

	if chase_target and not is_instance_valid(chase_target):
		get_new_target()

	if target_frame > 4:
		dying.emit()
	else:
		sprite.frame = target_frame

	if direction.length() > 0.0:
		velocity += direction * chase_acceleration
		velocity = velocity.limit_length(chase_speed)
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.01)

	move_and_slide()

func get_new_target() -> void:
	if chase_target_type == "":
		chase_target = null
		return

	var nearest: Node2D = null

	for target in globals.game_node.find_children("*", chase_target_type):
		if not is_instance_valid(target):
			continue

		if not nearest:
			nearest = target
		else:
			if global_position.distance_to(target.global_position) < global_position.distance_to(nearest.global_position):
				nearest = target

	chase_target = nearest


func _on_droplet_deleter_body_entered(body: Node2D) -> void:
	if body is Droplet:
		body.queue_free()


func _on_freeze_area_body_entered(body: Node2D) -> void:
	if body.get("freeze_sources") == null:
		return

	body.freeze_sources.append(self)


func _on_freeze_area_body_exited(body: Node2D) -> void:
	if body.get("freeze_sources") == null:
		return

	body.freeze_sources.erase(self)
