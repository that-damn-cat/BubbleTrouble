class_name WarmthComponent
extends StatComponent

@export var thaw_rate: float

var is_frozen: bool = false

var is_thaw: bool:
	get:
		return not is_frozen

signal froze
signal thawed

func _process(delta: float) -> void:
	if is_empty and not is_frozen:
		froze.emit()
		is_frozen = true

	if is_full and is_frozen:
		thawed.emit()
		is_frozen = false

	value += thaw_rate * delta