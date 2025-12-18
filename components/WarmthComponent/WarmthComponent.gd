class_name WarmthComponent
extends StatComponent

@export var thaw_rate: float

var is_frozen: bool = false

var is_thaw: bool:
	get:
		return not is_frozen

func _process(delta: float) -> void:
	if is_empty:
		is_frozen = true

	if is_full:
		is_frozen = false

	value += thaw_rate * delta