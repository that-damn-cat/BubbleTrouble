@tool
extends Marker2D

@export var rotation_rate: float = 0.0

func _process(delta: float) -> void:
	self.rotate(rotation_rate * delta)