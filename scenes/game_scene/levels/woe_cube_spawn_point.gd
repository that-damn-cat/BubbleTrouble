extends Marker2D

@export var cubescene : PackedScene
func _on_woe_cube_spawn_timer_timeout() -> void:
	var newCube = cubescene.instantiate()
	%Enemies.add_child(newCube)
	newCube.position = global_position
