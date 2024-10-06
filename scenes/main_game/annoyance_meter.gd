extends Node2D

signal annoyance_filled

@onready var slider: Slider = $HSlider

@export var max_annoyance_value: float = 100

var current_annoyance_value: float = 0

var headi_1: Image = Image.load_from_file("res://assets/characters/head1.png")
var headi_2: Image = Image.load_from_file("res://assets/characters/head1.2.png")
var headi_3: Image = Image.load_from_file("res://assets/characters/head1.3.png")
var headi_4: Image = Image.load_from_file("res://assets/characters/head1.4.png")
var headi_5: Image = Image.load_from_file("res://assets/characters/head1.5.png")

func _ready() -> void:
	slider.max_value = max_annoyance_value
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
