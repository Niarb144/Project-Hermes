extends Node

@export var enemy_spawner: Node2D
@export var asteroid_enemy: PackedScene
@export var shooter_enemy: PackedScene
@export var boss_enemy: PackedScene

var level_1_waves = [
	{ "enemy": "asteroid", "count": 1 },
	{ "enemy": "shooter", "count": 1 },
	{ "enemy": "mixed", "count": 8 }
]

var current_wave := 0
var enemies_to_kill := 0
var enemies_killed := 0
var player_alive := true
var spawning := false

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.player_died.connect(_on_player_died)
	start_level_1()


func start_level_1():
	current_wave = 0
	start_wave()


func start_wave():
	enemies_killed = 0
	enemies_to_kill = level_1_waves[current_wave]["count"]
	spawning = true

	match level_1_waves[current_wave]["enemy"]:
		"asteroid":
			spawn_wave_with_delay(asteroid_enemy, enemies_to_kill)

		"shooter":
			spawn_wave_with_delay(shooter_enemy, enemies_to_kill)

		"mixed":
			spawn_mixed_wave_with_delay(enemies_to_kill)
			
func spawn_wave_with_delay(enemy_scene: PackedScene, count: int):
	for i in count:
		if not player_alive:
			return

		var enemy = enemy_spawner.spawn_enemy(enemy_scene)
		enemy.enemy_died.connect(_on_enemy_died, CONNECT_ONE_SHOT)

		await get_tree().create_timer(0.6).timeout


			
func spawn_wave(enemy_scene: PackedScene, count: int):
	for i in count:
		var enemy = enemy_spawner.spawn_enemy(enemy_scene)
		enemy.enemy_died.connect(_on_enemy_died)

func spawn_mixed_wave_with_delay(count: int):
	for i in count:
		if not player_alive:
			return

		var scene = asteroid_enemy if randf() < 0.5 else shooter_enemy
		var enemy = enemy_spawner.spawn_enemy(scene)
		enemy.enemy_died.connect(_on_enemy_died, CONNECT_ONE_SHOT)

		await get_tree().create_timer(0.6).timeout

		
func _on_enemy_died():
	if not player_alive:
		return

	enemies_killed += 1

	if enemies_killed >= enemies_to_kill:
		current_wave += 1
		spawning = false

		if current_wave < level_1_waves.size():
			await get_tree().create_timer(2.0).timeout
			start_wave()
		else:
			spawn_boss()

			
func spawn_boss():
	var boss = boss_enemy.instantiate()
	boss.position = Vector2(
		get_viewport().size.x / 2,
		-150
	)
	boss.enemy_died.connect(_on_boss_died, CONNECT_ONE_SHOT)
	get_parent().add_child(boss)

	
func _on_player_died():
	player_alive = false
	print("GAME OVER")

	
func _on_boss_died():
	level_complete()

func level_complete():
	print("LEVEL COMPLETE!")
