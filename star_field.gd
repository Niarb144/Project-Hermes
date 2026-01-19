extends Node2D

@export var star_scene: PackedScene
@export var star_count := 150

var screen_size: Vector2

func _ready():
	screen_size = get_viewport_rect().size

	for i in star_count:
		spawn_star()

func spawn_star():
	var star = star_scene.instantiate()
	star.position = Vector2(
		randf_range(0, screen_size.x),
		randf_range(0, screen_size.y)
	)
	$Stars.add_child(star)
