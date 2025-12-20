class_name Player
extends CharacterBody2D

@export_category("Components")
@export var grow_component: GrowComponent
@export var health_component: HealthComponent
@export var warmth_component: WarmthComponent

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
@export var min_speed: float = 350.0
@export var max_speed: float = 550.0
@export_range(0.0, 1.0, 0.01) var friction = .06
@export var bounce_damping: float = 0.6

var direction := Vector2.ZERO

var freeze_sources: Array[WoeCube] = []

signal mass_changed

func _ready() -> void:
	for collider in grow_component.collision_offsets.keys():
		collider.shape = CircleShape2D.new()

	health_component.max_health = max_mass
	health_component.current_health = mass
	update_mass()


func _process(delta: float) -> void:
	if mass < min_mass:
		health_component.current_health = 0.0

	clean_array(freeze_sources)
	var total_freeze_rate: float = 0.0

	for source in freeze_sources:
		total_freeze_rate += source.freeze_rate

	warmth_component.value -= total_freeze_rate * delta

	%Bubs.material.set_shader_parameter("enabled", warmth_component.is_frozen)


func _physics_process(_delta) -> void:
	var acceleration = remap(mass, min_mass, max_mass, max_acceleration, min_acceleration)
	var speed_cap = remap(mass, min_mass, max_mass, max_speed, min_speed)

	if direction.length() > 0.0:
		velocity += direction * acceleration
		velocity = velocity.limit_length(speed_cap)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)

	move_and_slide()


func update_mass() -> void:
	mass = health_component.current_health
	grow_component.size = mass
	grow_component.update_size()
	mass_changed.emit()

	%StatbarPosition.position.y = -(mass + 5)


func merge(consumed: Player) -> void:
	var initial_health: float = health_component.current_health

	health_component.heal(consumed.mass)
	update_mass()

	var healed_amount: float = health_component.current_health - initial_health

	if healed_amount == consumed.mass:
		consumed.queue_free()
		return

	consumed.mass = consumed.mass - healed_amount
	consumed.update_mass()


func _on_merge_area_body_entered(body: Node2D) -> void:
	if body == self:
		return

	if health_component.current_health == health_component.max_health:
		if body is Droplet:
			%Active.try_split()
		return

	if body is Player:
		if mass < body.mass:
			return

		merge(body)
		return

	if body is Droplet:
		health_component.heal(body.size_bonus)
		update_mass()
		body.queue_free()

func _on_healed(_amount: float) -> void:
	#if health_component.current_health == health_component.max_health:
	#	%MergeCollider.set_deferred("disabled", true)
	%GrowSFX.play_jitter()
	update_mass()

func _on_damaged(_amount: float) -> void:
	#%MergeCollider.set_deferred("disabled", false)
	update_mass()

func clean_array(arr: Array) -> void:
	var to_remove: Array[int] = []

	for index in range(arr.size()):
		if arr[index] == null or not is_instance_valid(arr[index]):
			to_remove.append(index)

	for index in to_remove:
		if index < arr.size():
			arr.remove_at(index)
