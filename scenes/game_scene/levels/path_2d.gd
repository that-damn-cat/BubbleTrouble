extends Path2D

@export var sponge_speed : float
func _process(delta: float) -> void:
	if $SpongeAttach.progress_ratio <= 0.0 or $SpongeAttach.progress_ratio >= 1.0:
		sponge_speed *= -1.0

	$SpongeAttach.progress_ratio += sponge_speed * delta
