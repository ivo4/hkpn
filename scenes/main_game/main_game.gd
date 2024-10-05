extends Node2D


@onready var annoyance_meter: Node2D = $AnnoyanceMeter


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_fight_game_damage(amount: float) -> void:
	annoyance_meter.deal_damage(amount)
