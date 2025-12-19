extends Node

signal data_ready

var scaling_factor: float = 2.0

var game_node: Node = null
var player_container: Node = null
var enemy_container: Node = null
var pickup_container: Node = null
var data_filled: bool = false
var level_title: String = ""

var num_lives: int = 3

func _process(_delta: float) -> void:
	if data_filled:
		return

	if game_node and player_container and enemy_container and pickup_container:
		data_filled = true
		data_ready.emit()
	else:
		data_filled = false