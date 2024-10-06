extends Control


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		_start_game()

func _start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/main_game/main_game.tscn")
