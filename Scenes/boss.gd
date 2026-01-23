extends Area2D

signal enemy_died

@export var max_health := 5
@export var entry_speed := 120.0
@export var horizontal_speed := 150.0
@export var entry_y := 120.0

@export var bullet_scene: PackedScene
@export var fire_rate := 0.8

var health: int
var entering := true
var direction := 1
var screen_size: Vector2

@onready var gun = $Gun
@onready var shoot_timer := $ShootTimer
@onready var sprite := $Sprite2D

func _ready():
	health = max_health
	screen_size = get_viewport_rect().size
	#sprite.play("idle")

	shoot_timer.wait_time = fire_rate
	shoot_timer.stop() # only starts after entry


func _process(delta):
	if entering:
		_handle_entry(delta)
	else:
		_handle_movement(delta)


# -----------------------
# Entry Phase
# -----------------------
func _handle_entry(delta):
	position.y += entry_speed * delta

	if position.y >= entry_y:
		position.y = entry_y
		entering = false
		shoot_timer.start()


# -----------------------
# Combat Movement
# -----------------------
func _handle_movement(delta):
	position.x += direction * horizontal_speed * delta

	if position.x < 60:
		direction = 1
	elif position.x > screen_size.x - 60:
		direction = -1


# -----------------------
# Shooting
# -----------------------
func _on_ShootTimer_timeout():
	shoot()

func shoot():
	if bullet_scene == null:
		push_error("Bullet scene not assigned on shooter enemy")
		return

	var bullet = bullet_scene.instantiate()
	get_parent().add_child.call_deferred(bullet)
	bullet.global_position = gun.global_position
	bullet.add_to_group("enemy_bullets")


# -----------------------
# Damage & Death
# -----------------------
func take_damage(amount: int):
	health -= amount
	hit_flash()
	if health <= 0:
		die()
		
func hit_flash():
	modulate = Color(1, 0.4, 0.4)
	await get_tree().create_timer(0.05).timeout
	modulate = Color.WHITE

func die():
	shoot_timer.stop()
	emit_signal("enemy_died")
	queue_free()

# -----------------------
# Collisions
# -----------------------
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullets"):
		take_damage(area.damage)
		area.queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(3)
