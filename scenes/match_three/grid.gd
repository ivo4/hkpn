extends Area2D

@export var tile_scene: PackedScene

const rows: int = 7
const columns: int = 7
const tile_size: int = 64
const gap: int = 6
const tile_size_with_gap: int = tile_size + gap

var tiles = []
var dragged_tile: Tile
var neighbour_tile: Tile
var resetting_tiles = []

const tile_reset_speed = 400

func _ready():
	tiles.resize(columns)

	for x in range(columns):
		tiles[x] = []
		tiles[x].resize(rows)

		for y in range(rows):
			var tile: Tile = tile_scene.instantiate()
			tile.index = Vector2(x, y)
			resetPosition(tile)
			tile.connect("drag_started", Callable(self, "_on_tile_drag_started"))
			add_child(tile)
			tiles[x][y] = tile

func _on_tile_drag_started(tile: Tile):
	if resetting_tiles.is_empty():
		dragged_tile = tile
		set_process_input(true)

func _input(event):
	if dragged_tile:
		if event is InputEventMouseMotion:
			var diff = event.position - dragged_tile.drag_start_pos

			if abs(diff.x) > abs(diff.y):
				diff.y = 0
				diff.x = clamp(diff.x, -tile_size_with_gap, tile_size_with_gap)
			else:
				diff.x = 0
				diff.y = clamp(diff.y, -tile_size_with_gap, tile_size_with_gap)

			var neighbour_index = dragged_tile.index + sign(diff)

			if isValidIndex(neighbour_index):
				dragged_tile.position = getDefaultPos(dragged_tile.index) + diff
				var new_neighbour_tile = tiles[neighbour_index.x][neighbour_index.y]

				if (neighbour_tile && new_neighbour_tile != neighbour_tile):
					resetPosition(neighbour_tile)

				neighbour_tile = new_neighbour_tile
				neighbour_tile.position = getDefaultPos(neighbour_tile.index) - diff
			else:
				resetPosition(dragged_tile)

				if neighbour_tile:
					resetPosition(neighbour_tile)

		if event is InputEventMouseButton:
			if !event.pressed:
				resetting_tiles = [dragged_tile, neighbour_tile]
				dragged_tile.onDragEnd()
				dragged_tile = null
				neighbour_tile = null
				set_process_input(false)

func getDefaultPos(index: Vector2) -> Vector2:
	return index * tile_size_with_gap

func resetPosition(tile: Tile):
	tile.position = getDefaultPos(tile.index)

func isValidIndex(index: Vector2) -> bool:
	return index.x >= 0 and index.x < columns and index.y >= 0 and index.y < rows

func _process(delta):
	if !resetting_tiles.is_empty():
		for tile in resetting_tiles:
			if !tile:
				resetting_tiles.erase(tile)
				continue

			var target = getDefaultPos(tile.index)
			tile.position = tile.position.move_toward(target, tile_reset_speed * delta)

			if tile.position.distance_to(target) < 1:
				resetting_tiles.erase(tile)
				resetPosition(tile)
				tile.z_index = 0
