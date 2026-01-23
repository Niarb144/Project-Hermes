extends CanvasLayer

@onready var progress_bar := $Panel/LevelProgressBar
@onready var progress_label := $Panel/ProgressText
@onready var restart_button := $Panel/RestartButton
@onready var quit_button := $Panel/QuitButton

func _ready():
	hide()

	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func show_game_over(killed: int, total: int):
	show()
	get_tree().paused = true

	progress_bar.max_value = total
	progress_bar.value = killed

	var percent := int((killed / float(total)) * 100)
	progress_label.text = "Objective: %d%% (%d / %d)" % [percent, killed, total]

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	print("Restart Game")

func _on_quit_pressed():
	get_tree().quit()
