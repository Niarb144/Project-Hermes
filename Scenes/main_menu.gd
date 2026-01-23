extends Control

@onready var video := $VideoStreamPlayer
@onready var music := $Music
@onready var controls_panel := $ControlsPanel

func _ready():
	controls_panel.hide()
	get_tree().paused = false
	Engine.time_scale = 1.0

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	
func _on_controls_button_pressed():
	controls_panel.show()
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_back_button_pressed() -> void:
	controls_panel.hide()
