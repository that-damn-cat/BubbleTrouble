class_name Droplet
extends CharacterBody2D

@export var size_bonus: float = 5.0
@export var grow_component: GrowComponent
@export var sprite: Sprite2D

@export_category("Physics")
@export var friction: float = 0.03
@export var bounce_damping: float = 0.6

@export_category("Droplet Clustering")
@export var attraction_radius: float = 30.0
@export var attraction_strength: float = 20.0
@export var max_attract_force: float = 40.0

func _ready() -> void:
	grow_component.size = sprite.texture.get_size().x / 2.0
	grow_component.update_size()

func _physics_process(delta: float) -> void:
	apply_attraction()

	velocity = lerp(velocity, Vector2.ZERO, friction)
	var collision := move_and_collide(velocity * delta)

	if collision:
		handle_collision(collision)

func apply_attraction() -> void:
	for droplet in get_tree().get_nodes_in_group("Droplets"):
		droplet = droplet as Droplet

		if droplet == self:
			continue

		var direction: Vector2 = global_position.direction_to(droplet.global_position)
		var distance: float = direction.length()

		if distance > attraction_radius or distance == 0.0:
			continue

		var force: float = attraction_strength / max(distance * distance, 20.0)
		force = min(force, max_attract_force)

		velocity += direction.normalized() * force
		velocity *= 0.995


func handle_collision(collision: KinematicCollision2D) -> void:
	velocity = velocity.bounce(collision.get_normal()) * bounce_damping

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return

	body = body as Player

	body.health_component.heal(size_bonus)

	queue_free()
