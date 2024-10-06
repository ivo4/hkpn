extends Control

@onready var time_label = $TimeLabel

func _ready() -> void:
	time_label.text = str(int(Global.last_result)) + " seconds"


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
