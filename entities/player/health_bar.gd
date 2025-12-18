extends ProgressBar

@export var player: Player
@export var min_width: float
@export var max_width: float

func _on_mass_changed() -> void:
	if not is_instance_valid(player):
		return

	custom_minimum_size.x = remap(player.mass, player.min_mass, player.max_mass, min_width, max_width)