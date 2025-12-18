extends ProgressBar

@export var warmth: WarmthComponent
@export var warm_color: Color
@export var frozen_color: Color
@export var tween_time: float = 0.5

var color_tween: Tween
var visibility_tween: Tween
var last_freeze_state: bool = false
var last_full_state: bool = true

func _on_warmth_changed(_delta: float) -> void:
	if not is_instance_valid(warmth):
		return

	value = remap(warmth.value, warmth.min_value, warmth.max_value, min_value, max_value)

	if warmth.is_frozen != last_freeze_state:
		tween_color()

	if warmth.is_full != last_full_state:
		tween_visibility()

	last_freeze_state = warmth.is_frozen
	last_full_state = warmth.is_full

func tween_color() -> void:
	if color_tween:
		color_tween.kill()

	var target_color: Color = warm_color

	if warmth.is_frozen:
		target_color = frozen_color

	color_tween = create_tween()

	color_tween.tween_property(get_theme_stylebox("fill"), "bg_color", target_color, tween_time)


func tween_visibility() -> void:
	if visibility_tween:
		visibility_tween.kill()

	var vis_value: float = 1.0

	if warmth.is_full:
		vis_value = 0.0

	visibility_tween = create_tween()
	visibility_tween.tween_property(self, "self_modulate:a", vis_value, tween_time)
