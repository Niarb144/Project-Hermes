extends Area2D

signal enemy_died

@export var speed := 120.0
@export var max_health := 3
@export var contact_damage := 1

@export var bullet_scene: PackedScene
@export var fire_rate := 1.2

var health: int
var direction := Vector2.DOWN
var screen_size: Vector2

@onready var gun = $Gun
@onready var shoot_timer = $ShootTimer
@onready var anim = $AnimatedSprite2D

func _ready():
	health = max_health
	screen_size = get_viewport_rect().size
	
	anim.play("idle")
	
	shoot_timer.wait_time= fire_rate
	shoot_timer.start()
	
func _process(delta):
	position += direction.normalized() * speed * delta
	
	if position.y > screen_size.y + 50:
		queue_free()


func _on_shoot_timer_timeout() -> void:
	shoot()
	
func shoot():
	if bullet_scene == null:
		push_error("Bullet scene not assigned on shooter enemy")
		return

	var bullet = bullet_scene.instantiate()
	get_parent().add_child.call_deferred(bullet)
	bullet.global_position = gun.global_position
	bullet.add_to_group("enemy_bullets")
	
func take_damage(amount: int):
	health -= amount
	hit_flash()

	if health <= 0:
		die()
		
func hit_flash():
	anim.modulate = Color.WHITE
	await get_tree().create_timer(0.05).timeout
	anim.modulate = Color(1, 1, 1)

func die():
	emit_signal("enemy_died")
	queue_free()

	


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(contact_damage)
		die()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullets"):
		take_damage(area.damage)
		area.queue_free()
