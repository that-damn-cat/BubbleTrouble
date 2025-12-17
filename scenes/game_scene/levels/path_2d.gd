extends Path2D


@export var spongeSpeed : float

func _process(delta: float) -> void:
	$SpongeAttach.progress_ratio += spongeSpeed * delta
