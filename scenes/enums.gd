extends Node

enum TileColor {
	DARKBLUE,
	LIGHTBLUE,
	ORANGE,
	RED,
	YELLOW,
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
		TileColor.DARKBLUE:
			return "Dark Blue"
		TileColor.LIGHTBLUE:
			return "Light Blue"
		TileColor.ORANGE:
			return "Orange"
		TileColor.RED:
			return "Red"
		TileColor.YELLOW:
			return "Yellow"

	return "Unknown"

func get_random_tile_icon() -> TileIcon:
	init_rng_if_needed()
	var icons = TileIcon.values()

	# Most of the time you get NONE
	var index = rng.randi() % 10

	if index >= icons.size():
		return TileIcon.NONE

	return icons[index]
