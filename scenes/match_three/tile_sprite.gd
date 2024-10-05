extends Sprite2D

@export var texture_red: Texture
@export var texture_green: Texture
@export var texture_blue: Texture

const TileColor = Enums.TileColor

var color: TileColor = Enums.get_random_tile_color()

func _ready():
	match color:
		TileColor.GREEN:
			texture = texture_green
		TileColor.BLUE:
			texture = texture_blue
		_:
			texture = texture_red

func _process(_delta):
	pass
