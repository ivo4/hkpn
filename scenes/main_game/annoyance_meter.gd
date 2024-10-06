extends Node2D

signal annoyance_filled

@onready var slider: HSlider = $HSlider

@export var max_annoyance_value: float = 100

var current_annoyance_value: float = 0

func _ready() -> void:
	slider.max_value = max_annoyance_value

func _process(_delta: float) -> void:
	slider.value = current_annoyance_value

func deal_damage(amount: float) -> void:
	current_annoyance_value += amount

func recover_damage(amount: float) -> void:
	current_annoyance_value -= amount

func _on_h_slider_value_changed(value: float) -> void:
	if (value >= max_annoyance_value):
		annoyance_filled.emit()
