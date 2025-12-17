class_name Drain
extends Marker2D

@export var drain_gravity = 3200.0
@export var drain_dps: float = 10.0

var velocity_bodies: Array[CharacterBody2D]
var draining_players: Array[Player]

func _ready() -> void:
	await globals.data_ready

	#globals.player_container.child_entered_tree.connect(add_affected_child)
	#globals.enemy_container.child_entered_tree.connect(add_affected_child)
	globals.pickup_container.child_entered_tree.connect(add_affected_child)

	#globals.player_container.child_exiting_tree.connect(remove_affected_child)
	#globals.enemy_container.child_exiting_tree.connect(remove_affected_child)
	globals.pickup_container.child_exiting_tree.connect(add_affected_child)

	# for child in globals.player_container.get_children():
	# 	add_affected_child(child)

	# for child in globals.enemy_container.get_children():
	# 	add_affected_child(child)

	for child in globals.pickup_container.get_children():
		add_affected_child(child)

func _process(delta):
	clean_array(draining_players)

	for player in draining_players:
		if not is_instance_valid(player):
			continue

		player.health_component.damage(drain_dps * delta)

func _physics_process(_delta: float) -> void:
	for body in velocity_bodies:
		if not is_instance_valid(body):
			continue

		var gravity_direction: Vector2 = body.global_position.direction_to(global_position)

		var body_mass = body.get("mass")
		if not body_mass:
			body_mass = 16.0

		var radius_squared = pow(global_position.distance_to(body.global_position), 2)

		body.velocity += gravity_direction * ((drain_gravity * body_mass) / radius_squared)

	clean_array(velocity_bodies)

func add_affected_child(node: Node) -> void:
	if not node is CharacterBody2D:
		return

	node = node as CharacterBody2D

	if node in velocity_bodies:
		return

	velocity_bodies.append(node)

func remove_affected_child(node: Node) -> void:
	if not node is CharacterBody2D:
		return

	node = node as CharacterBody2D

	if not node in velocity_bodies:
		return

	velocity_bodies.erase(node)

func clean_array(arr: Array) -> void:
	var to_remove: Array[int] = []

	for index in range(arr.size()):
		if arr[index] == null:
			to_remove.append(index)

	for index in to_remove:
		if index < arr.size():
			arr.remove_at(index)