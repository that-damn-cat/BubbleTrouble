extends Path2D

@export var spongeratio : float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	%FollowerNode.progress_ratio += spongeratio * delta
