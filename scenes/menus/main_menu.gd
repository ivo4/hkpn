extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Settings.visible = false
	$Credits.visible = false
	$Tutorial.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/intro_cutscene.tscn")


func _on_tutorial_button_pressed() -> void:
	$Tutorial.visible = true


func _on_tutorial_close_button_pressed() -> void:
	$Tutorial.visible = false


func _on_settings_button_pressed() -> void:
	$Settings.visible = true


func _on_settings_close_button_pressed() -> void:
	$Settings.visible = false


func _on_credits_button_pressed() -> void:
	$Credits.visible = true


func _on_credits_close_button_pressed() -> void:
	$Credits.visible = false


func _on_volume_slider_value_changed(value: float) -> void:
	print_debug(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
