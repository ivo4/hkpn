extends Area2D

@export var tile_scene: PackedScene

const rows: int = 7
const columns: int = 7
const tile_size: Vector2 = Vector2(64, 64)
const gap: int = 6

func _ready():
	for y in range(rows):
		for x in range(columns):
			var tile_instance = tile_scene.instantiate()
			tile_instance.position = Vector2(x * (tile_size.x + gap), y * (tile_size.y + gap))
			add_child(tile_instance)
