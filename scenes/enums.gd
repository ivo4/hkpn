extends Node

enum TileColor {
	RED,
	GREEN,
	BLUE,
	YELLOW,
	BROWN,
	PURPLE,
}

enum WEAPON {
	SLAP,
	SPRAY,
}

enum TileIcon {
	NONE,
	SPRAY,
	ZAPPER,
}

var rng: RandomNumberGenerator

func init_rng_if_needed():
	if !rng:
		rng = RandomNumberGenerator.new()
		# rng.seed = 6 # TODO remove

func get_random_tile_color() -> TileColor:
	init_rng_if_needed()
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

func get_random_tile_icon() -> TileIcon:
	init_rng_if_needed()
	var icons = TileIcon.values()

	# Most of the time you get NONE
	var index = rng.randi() % 12

	if index >= icons.size():
		return TileIcon.NONE

	return icons[index]
