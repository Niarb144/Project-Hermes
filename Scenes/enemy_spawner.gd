extends Node2D

@export var min_spawn_delay := 0.5
@export var max_spawn_delay := 1.5

@export var min_speed := 120.0
@export var max_speed := 220.0

@export var horizontal_margin := 40

var screen_size: Vector2
var spawning := false
var last_region := -1

func _ready():
	screen_size = get_viewport_rect().size

	
func spawn_loop(enemy_scene: PackedScene):
	spawning = true
	while spawning:
		spawn_enemy(enemy_scene)
		await get_tree().create_timer(
			randf_range(min_spawn_delay, max_spawn_delay)
		).timeout

		
func spawn_enemy(enemy_scene: PackedScene):
	var enemy = enemy_scene.instantiate()
	
	# Divide screen into 3 regions
	var region = randi() % 3

	var spawn_x: float
	var direction: Vector2

	match region:
		0: # LEFT region
			spawn_x = randf_range(
				horizontal_margin,
				screen_size.x * 0.33
			)
			direction = Vector2(0.3, 1) # drift right

		1: # CENTER region
			spawn_x = randf_range(
				screen_size.x * 0.33,
				screen_size.x * 0.66
			)
			direction = Vector2(0, 1) # straight down

		2: # RIGHT region
			spawn_x = randf_range(
				screen_size.x * 0.66,
				screen_size.x - horizontal_margin
			)
			direction = Vector2(-0.3, 1) # drift left

	enemy.position = Vector2(spawn_x, -40)

	# Add slight randomness so it doesn't feel robotic
	direction.x += randf_range(-0.15, 0.15)
	enemy.direction = direction.normalized()

	enemy.speed = randf_range(min_speed, max_speed)

	get_parent().add_child.call_deferred(enemy)
	return enemy

	
func stop():
	spawning = false
