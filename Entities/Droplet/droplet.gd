class_name Droplet
extends CharacterBody2D

@export var size_bonus: float = 5.0
@export var grow_component: GrowComponent
@export var sprite: Sprite2D

@export_category("Physics")
@export var mass: float = 8.0
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

	velocity *= 0.995

	var collision := move_and_collide(velocity * delta)

	if collision:
		velocity = velocity.bounce(collision.get_normal()) * bounce_damping

# Help, I was in a fugue state late last night and don't know what these physics do anymore
func apply_attraction() -> void:
	var attractors := get_tree().get_nodes_in_group("Droplets")
	attractors.append_array(get_tree().get_nodes_in_group("Players"))

	for droplet in attractors:
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
