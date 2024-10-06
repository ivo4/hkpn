extends Sprite2D

const textureDarkBlue = preload("res://assets/sprites/tile-darkblue.png")
const textureLightBlue = preload("res://assets/sprites/tile-lightblue.png")
const textureOrange = preload("res://assets/sprites/tile-orange.png")
const textureRed = preload("res://assets/sprites/tile-red.png")
const textureYellow = preload("res://assets/sprites/tile-yellow.png")

const TileColor = Enums.TileColor

func _ready():
	var tile: Tile = get_parent()

	match tile.color:
		TileColor.DARKBLUE:
			texture = textureDarkBlue
		TileColor.LIGHTBLUE:
			texture = textureLightBlue
		TileColor.ORANGE:
			texture = textureOrange
		TileColor.RED:
			texture = textureRed
		_:
			texture = textureYellow

func _process(_delta):
	pass
