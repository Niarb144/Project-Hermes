extends Area2D

@export var speed := 500.0
@export var damage := 2

var screen_size: Vector2

func _ready():
	screen_size = get_viewport_rect().size
	add_to_group("enemy_bullets")

func _process(delta):
	position.y += speed * delta

	if position.y > screen_size.y + 20:
		queue_free()
