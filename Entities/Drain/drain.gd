extends Marker2D

@export var drain_gravity = 1400.0
var velocity_bodies: Array[CharacterBody2D]

func _ready() -> void:
	pass
	# await globals.data_ready

	# globals.player_container.child_entered_tree.connect(add_affected_child)
	# globals.enemy_container.child_entered_tree.connect(add_affected_child)

	# globals.player_container.child_exiting_tree.connect(remove_affected_child)
	# globals.enemy_container.child_exiting_tree.connect(remove_affected_child)

	# for child in globals.player_container.get_children():
	# 	add_affected_child(child)

	# for child in globals.enemy_container.get_children():
	# 	add_affected_child(child)

func _physics_process(_delta: float) -> void:
	pass
	# for body in velocity_bodies:
	# 	var gravity_direction: Vector2 = body.global_position.direction_to(global_position)

	# 	var body_mass = body.get("mass")
	# 	if not body_mass:
	# 		body_mass = 16.0

	# 	var radius_squared = pow(global_position.distance_to(body.global_position), 2)

	# 	body.velocity += gravity_direction * ((drain_gravity * body_mass) / radius_squared)

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
