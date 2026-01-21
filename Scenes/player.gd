extends CharacterBody2D

@export var max_health := 5
@export var speed := 350.0
@export var acceleration := 1400.0
@export var friction := 900.0

@export var bullet_scene: PackedScene
@export var fire_rate := 0.4   # seconds between shots

@onready var shoot_sound = $ShootSound

signal player_died
signal health_changed(current, max)

var can_shoot := true
var health: int
var screen_size: Vector2

func _ready():
	screen_size = get_viewport_rect().size
	health = max_health
	emit_signal("health_changed", health, max_health)
	add_to_group("player")

func _physics_process(delta):
	var direction := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction.normalized() * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	handle_shooting()
	
	move_and_slide()

	clamp_to_screen()
	
func clamp_to_screen():
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
func handle_shooting():
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()
	
func shoot():
	can_shoot = false

	var bullet = bullet_scene.instantiate()
	bullet.global_position = $Gun.global_position
	bullet.rotation = randf_range(-0.05, 0.05)
	shoot_sound.play()
	
	get_parent().add_child(bullet)

	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
	
func take_damage(amount: int):
	health -= amount
	hit_flash()
	emit_signal("health_changed", health, max_health)
	
	if health <= 0:
		die()
		
func die():
	emit_signal("player_died")
	queue_free()

func hit_flash():
	modulate = Color(1, 0.4, 0.4)
	await get_tree().create_timer(0.05).timeout
	modulate = Color.WHITE

func _on_player_died() -> void:
	pass # Replace with function body.
