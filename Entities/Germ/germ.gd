extends CharacterBody2D

@export var speed : float = 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_slide()

func seeYou(body: Node2D):
	var direction = global_position.direction_to(body.global_position)
	velocity = direction * speed

