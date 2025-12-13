extends Node

func _ready() -> void:
	globals.player_container = %Players
	globals.enemy_container = %Enemies
	globals.pickup_container = %Pickups