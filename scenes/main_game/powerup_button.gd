@tool
extends Node2D

signal powerup_activated

@export var max_value: int = 100
@export var current_value: int:
	get:
		return current_value
	set(value):
		current_value = clampi(value, 0, max_value)
@export var button_texture: Texture2D:
	get:
		return button_texture
	set(value):
		button_texture = value


func _ready() -> void:
	$ButtonProgressMask/TextureButton.disabled = true
	$ButtonProgressMask/TextureButton.texture_normal = button_texture
	$GrayBackground.texture = button_texture
	$ButtonProgressMask.texture = PlaceholderTexture2D.new()
	$ButtonProgressMask.texture.size.x = button_texture.get_size().x
	$ButtonProgressMask.texture.size.y = button_texture.get_size().y


func _process(_delta: float) -> void:
	$ButtonProgressMask.offset.y = $ButtonProgressMask.texture.size.y
	var current_offset_percent: float = 100.0 * current_value / max_value
	$ButtonProgressMask.offset.y = $ButtonProgressMask.texture.size.y - ($ButtonProgressMask.texture.size.y * current_offset_percent / 100)
	$ButtonProgressMask/TextureButton.disabled = (current_value != max_value)


func _on_texture_button_pressed() -> void:
	print("powerup clicked")
	powerup_activated.emit()


func reset_value() -> void:
	current_value = 0


func increase_value(value: int) -> void:
	current_value += value
