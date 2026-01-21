extends CanvasLayer

@onready var player_health_bar: ProgressBar = $HealthBar

func connect_player(player):
	if not player:
		push_error("PlayerHealthBar not found in HUD")
		return
	
	player_health_bar.max_value = player.max_health
	player_health_bar.value = player.max_health

	player.health_changed.connect(_on_player_health_changed)
	
func _on_player_health_changed(current, max):
	player_health_bar.max_value = max
	player_health_bar.value = current
