extends HBoxContainer

@export var life_texture: Texture2D

var icon_array: Array[TextureRect]

var last_life_count: int = 0

func _process(_delta) -> void:
	if globals.num_lives == last_life_count:
		return

	refresh_counter()
	last_life_count = globals.num_lives

func refresh_counter() -> void:
	for child in get_children():
		if child is TextureRect:
			child.queue_free()

	for life in range(globals.num_lives):
		var new_icon := TextureRect.new()
		new_icon.texture = life_texture
		new_icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		add_child(new_icon)
		move_child(new_icon, 1)