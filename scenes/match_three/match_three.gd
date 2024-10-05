extends Node2D

signal matched(count: int, color: Enums.TileColor)


func _on_grid_matched(count: int, color: Enums.TileColor) -> void:
	matched.emit(count, color)
