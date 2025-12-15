class_name Droplet
extends CharacterBody2D

@export var size_bonus: float = 5.0
@export var grow_component: GrowComponent
@export var sprite: Sprite2D
@export var growth_rate: float = 0.5
@export var max_size_bonus: float = 15.0

@export_category("Physics")
@export var mass: float = 8.0
@export var friction: float = 0.03
@export var bounce_damping: float = 0.6

@export_category("Droplet Clustering")
@export var attraction_radius: float = 30.0
@export var attraction_strength: float = 20.0
@export var max_attract_force: float = 40.0

var growth_ratio: float = 0.0

func _ready() -> void:
	growth_ratio = (sprite.texture.get_size().x / 2.0) / size_bonus
	update_size()

func _process(delta) -> void:
	size_bonus += growth_rate * delta
	size_bonus = clamp(size_bonus, 1.0, max_size_bonus)
	update_size()

func update_size() -> void:
	grow_component.size = growth_ratio * size_bonus
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
