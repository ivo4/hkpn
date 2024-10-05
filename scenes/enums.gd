extends Node

enum TileColor {
	RED,
	GREEN,
	BLUE,
	YELLOW,
	BROWN,
	PURPLE,
}

var rng: RandomNumberGenerator

func get_random_tile_color() -> TileColor:
	if !rng:
		rng = RandomNumberGenerator.new()
		# rng.seed = 6 # TODO remove

	var colors = TileColor.values()
	var index = rng.randi() % colors.size()
	return colors[index]

func color_to_string(color: TileColor) -> String:
	match color:
		TileColor.RED:
			return "Red"
		TileColor.GREEN:
			return "Green"
		TileColor.BLUE:
			return "Blue"
		TileColor.YELLOW:
			return "Yellow"
		TileColor.BROWN:
			return "Brown"
		TileColor.PURPLE:
			return "Purple"

	return "Unknown"
