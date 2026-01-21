extends Area2D

@export var speed := 500.0
@export var damage := 2

func _ready():
	add_to_group("enemy_bullets")

func _process(delta):
	position.y += speed * delta

	if position.y > get_viewport_rect().size.y + 20:
		queue_free()

func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		body.take_damage(damage)
		print("Enemy bullet hit:", body.name)
		queue_free()
