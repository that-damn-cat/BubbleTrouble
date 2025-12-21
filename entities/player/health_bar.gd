extends ProgressBar

@export var player: Player
@export var min_width: float
@export var max_width: float

func _ready() -> void:
	max_value = player.max_mass
	min_value = 0.0

func _on_mass_changed() -> void:
	if not is_instance_valid(player):
		return

	value = player.mass

	visible = player.mass >= 20.0