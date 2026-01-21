extends Node

@export var enemy_spawner: Node2D
@export var asteroid_enemy: PackedScene
@export var shooter_enemy: PackedScene
@export var boss_enemy: PackedScene
@export var hud: CanvasLayer


# Wave definitions
var level_1_waves = [
	{ "enemy": "asteroid", "count": 3 },
	{ "enemy": "shooter", "count": 3 },
	{ "enemy": "mixed", "count": 3 }
]

# Wave state
var current_wave := 0
var enemies_to_kill := 0
var enemies_killed := 0
var player_alive := true
var spawning := false
var wave_ending := false


func _ready():
	var player = get_tree().get_first_node_in_group("player")
	#$HUD.connect_player(player)
	if player and hud:
		hud.call_deferred("connect_player", player)
	if player:
		player.player_died.connect(_on_player_died)
	start_level_1()


func start_level_1():
	current_wave = 0
	start_wave()


func start_wave():
	# SAFETY CHECK
	if current_wave >= level_1_waves.size():
		return

	enemies_killed = 0
	enemies_to_kill = level_1_waves[current_wave]["count"]
	spawning = true

	match level_1_waves[current_wave]["enemy"]:
		"asteroid":
			spawn_wave_with_delay(asteroid_enemy)
		"shooter":
			spawn_wave_with_delay(shooter_enemy)
		"mixed":
			spawn_mixed_wave_with_delay()



# --------------------------
# Continuous spawning loop
# --------------------------
func spawn_wave_with_delay(enemy_scene: PackedScene) -> void:
	spawning = true
	# async loop that runs until wave quota is reached or player dies
	while spawning and player_alive and enemies_killed < enemies_to_kill:
		var enemy = enemy_spawner.spawn_enemy(enemy_scene)
		enemy.enemy_died.connect(_on_enemy_died, CONNECT_ONE_SHOT)
		await get_tree().create_timer(randf_range(0.5, 1.0)).timeout

func spawn_mixed_wave_with_delay() -> void:
	spawning = true
	while spawning and player_alive and enemies_killed < enemies_to_kill:
		var scene = asteroid_enemy if randf() < 0.5 else shooter_enemy
		var enemy = enemy_spawner.spawn_enemy(scene)
		enemy.enemy_died.connect(_on_enemy_died, CONNECT_ONE_SHOT)
		await get_tree().create_timer(randf_range(0.5, 1.0)).timeout


# --------------------------
# Enemy death handler
# --------------------------
func _on_enemy_died():
	if not player_alive or wave_ending:
		return

	enemies_killed += 1

	if enemies_killed >= enemies_to_kill:
		wave_ending = true
		spawning = false
		current_wave += 1

		if current_wave < level_1_waves.size():
			await get_tree().create_timer(2.0).timeout
			wave_ending = false
			start_wave()
		else:
			spawn_boss()


# --------------------------
# Boss handling
# --------------------------
func spawn_boss():
	var boss = boss_enemy.instantiate()
	boss.position = Vector2(
		get_viewport().size.x / 2,
		-150
	)
	boss.enemy_died.connect(_on_boss_died, CONNECT_ONE_SHOT)
	get_parent().add_child.call_deferred(boss)


func _on_boss_died():
	level_complete()


# --------------------------
# Player death
# --------------------------
func _on_player_died():
	player_alive = false
	spawning = false
	print("GAME OVER")


# --------------------------
# Level complete
# --------------------------
func level_complete():
	print("LEVEL COMPLETE!")
