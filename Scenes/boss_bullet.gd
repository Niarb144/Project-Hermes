extends Area2D

@export var speed := 900.0
@export var damage := 1.5

var screen_size: Vector2

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	position.y -= speed * delta

	if position.y < -20:
		queue_free()
