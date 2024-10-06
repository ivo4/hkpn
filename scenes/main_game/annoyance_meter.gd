extends Node2D

signal annoyance_filled

@onready var slider: Slider = $HSlider

@export var max_annoyance_value: float = 100

var current_annoyance_value: float = 0

var headi_1: Image = preload("res://assets/characters/head1.png").get_image()
var headi_2: Image = preload("res://assets/characters/head1.2.png").get_image()
var headi_3: Image = preload("res://assets/characters/head1.3.png").get_image()
var headi_4: Image = preload("res://assets/characters/head1.4.png").get_image()
var headi_5: Image = preload("res://assets/characters/head1.5.png").get_image()

func _ready() -> void:
	slider.max_value = max_annoyance_value
	headi_1.rotate_90(CLOCKWISE)
	headi_2.rotate_90(CLOCKWISE)
	headi_3.rotate_90(CLOCKWISE)
	headi_4.rotate_90(CLOCKWISE)
	headi_5.rotate_90(CLOCKWISE)
	_change_grabber_icon(headi_1)

func _process(_delta: float) -> void:
	slider.value = current_annoyance_value

func _change_grabber_icon(image: Image) -> void:
	var tex: ImageTexture = ImageTexture.new()
	tex.set_image(image)
	tex.set_size_override(Vector2i(100, 100))
	slider.add_theme_icon_override("grabber_disabled", tex)

func deal_damage(amount: float) -> void:
	current_annoyance_value += amount

func recover_damage(amount: float) -> void:
	current_annoyance_value -= amount

func _on_h_slider_value_changed(value: float) -> void:
	if (value > 80):
		_change_grabber_icon(headi_5)
	elif (value > 60):
		_change_grabber_icon(headi_4)
	elif (value > 40):
		_change_grabber_icon(headi_3)
	elif (value > 20):
		_change_grabber_icon(headi_2)
	else:
		_change_grabber_icon(headi_1)

	if (value >= max_annoyance_value):
		annoyance_filled.emit()
