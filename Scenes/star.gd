extends Node2D

@export var speed_min := 50.0
@export var speed_max := 250.0
@export var speed_multiplier:= 1.0

var speed := 0.0
var screen_size: Vector2

func _ready():
	screen_size = get_viewport_rect().size
	speed = randf_range(speed_min, speed_max)

	# Random scale for depth illusion
	var scale_value = remap(speed, speed_min, speed_max, 0.4, 1.2)
	scale = Vector2.ONE * scale_value

func _process(delta):
	position.y += speed * delta
	modulate.a = 0.6 + sin(Time.get_ticks_msec() * 0.005 + position.x) * 0.3


	# Respawn at top
	if position.y > screen_size.y + 10:
		position.y = -10
		position.x = randf_range(0, screen_size.x)
