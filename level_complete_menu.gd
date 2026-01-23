extends CanvasLayer

@export var level_manager: Node

@onready var next_button := $Panel/NextLevelButton
@onready var menu_button := $Panel/MainMenuButton

func _ready():
	hide()
	#next_button.pressed.connect(_on_next_pressed)
	#menu_button.pressed.connect(_on_menu_pressed)

func show_menu():
	show()
	get_tree().paused = true

func _on_next_level_button_pressed() -> void:
	get_tree().paused = false
	level_manager.load_next_level()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
