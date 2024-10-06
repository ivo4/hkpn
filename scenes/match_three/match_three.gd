extends Node2D

signal matched(count: int, color: Enums.TileColor)
signal icon_collected(icon: Enums.TileIcon)

func _on_grid_matched(count: int, color: Enums.TileColor) -> void:
	matched.emit(count, color)

func _on_grid_icon_collected(icon: Enums.TileIcon) -> void:
	icon_collected.emit(icon)
