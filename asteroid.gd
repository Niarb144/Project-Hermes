extends Area2D

@export var speed := 80.0
@export var max_health := 0.5
@export var contact_damage := 0.5
@export var direction := Vector2.DOWN


@onready var explode_sound = $Explode
@onready var anim = $AnimatedSprite2D

signal enemy_died

var health: int
var screen_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	screen_size = get_viewport_rect().size
	anim.play("spin")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction.normalized() * speed * delta
	
	if position.y > screen_size.y + 50:
		queue_free()
		
func take_damage(amount: int):
	health -= amount
	hit_flash()
	
	if health <= 0:
		explode_sound.play()
		die()

func hit_flash():
	modulate = Color(1, 0.4, 0.4)
	await get_tree().create_timer(0.05).timeout
	modulate = Color.WHITE
	
func die():
	emit_signal("enemy_died")
	anim.stop()
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullets"):
		take_damage(area.damage)
		area.queue_free()
	
func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		body.take_damage(contact_damage)
		die()
