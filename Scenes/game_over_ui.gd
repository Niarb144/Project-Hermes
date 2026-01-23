extends CanvasLayer

@onready var progress_bar := $Panel/LevelProgressBar
@onready var progress_label := $Panel/ProgressText
@onready var restart_button := $Panel/RestartButton
@onready var quit_button := $Panel/QuitButton

func _ready():
	hide()

	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func show_game_over(progress: float):
	show()
	get_tree().paused = true
	
	var percent := int(progress * 100)
	progress_bar.max_value = 100
	progress_bar.value = percent

	progress_label.text = "Objective: %d%% Complete" % percent
	
func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	print("Restart Game")

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
