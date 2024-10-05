extends Sprite2D

@export var texture_red: Texture
@export var texture_green: Texture
@export var texture_blue: Texture
@export var texture_yellow: Texture
@export var texture_brown: Texture
@export var texture_purple: Texture

const TileColor = Enums.TileColor

func _ready():
	var tile: Tile = get_parent()

	match tile.color:
		TileColor.RED:
			texture = texture_red
		TileColor.GREEN:
			texture = texture_green
		TileColor.BLUE:
			texture = texture_blue
		TileColor.YELLOW:
			texture = texture_yellow
		TileColor.BROWN:
			texture = texture_brown
		_:
			texture = texture_purple

func _process(_delta):
	pass
