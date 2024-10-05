extends Node

enum TileColor {
	RED,
	GREEN,
	BLUE,
}

func get_random_tile_color() -> TileColor:
	var colors = TileColor.values()
	var index = randi() % colors.size()
	return colors[index]
