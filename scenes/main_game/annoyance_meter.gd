extends Node2D

@onready var slider: HSlider = $HSlider

func deal_damage(amount: float) -> void:
	slider.value = slider.value - amount
