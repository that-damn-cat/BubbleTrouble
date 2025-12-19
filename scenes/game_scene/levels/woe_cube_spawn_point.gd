extends Marker2D

@export var cube_scene : PackedScene
@export var chase_target: Node2D

func _on_woe_cube_spawn_timer_timeout() -> void:
	var new_cube: WoeCube = cube_scene.instantiate()
	new_cube.chase_target = chase_target
	new_cube.position = global_position
	%Enemies.add_child(new_cube)
