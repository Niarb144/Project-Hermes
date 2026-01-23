extends CanvasLayer

@export var level_manager: Node
@onready var controls_panel := $Panel/ControlsPanel

func _ready():
	hide()
	controls_panel.hide()

func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()
		get_viewport().set_input_as_handled()

func toggle_pause():
	if level_manager and level_manager.game_over:
		return

	if get_tree().paused:
		resume()
	else:
		pause()

func pause():
	show()
	get_tree().paused = true

func resume():
	hide()
	controls_panel.hide()
	get_tree().paused = false

func _on_resume_button_pressed():
	resume()

func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_controls_button_pressed():
	controls_panel.show()

func _on_back_button_pressed():
	controls_panel.hide()

func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
