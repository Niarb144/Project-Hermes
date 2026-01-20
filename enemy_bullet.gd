extends Area2D

@export var speed := 400.0
@export var damage := 1

func _process(delta):
	position.y += speed * delta

	if position.y > get_viewport_rect().size.y + 20:
		queue_free()
