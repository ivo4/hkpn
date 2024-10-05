extends Node

enum TileColor {
	RED,
	GREEN,
	BLUE,
	BROWN,
	GRAY,
}

var rng: RandomNumberGenerator

func get_random_tile_color() -> TileColor:
	if !rng:
		rng = RandomNumberGenerator.new()
		rng.seed = 6 # TODO remove

	var colors = TileColor.values()
	var index = rng.randi() % colors.size()
	return colors[index]
