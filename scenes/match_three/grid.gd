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
			reset_position(tile)
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
			on_tile_drag(event.position)

		if event is InputEventMouseButton:
			if !event.pressed:
				on_drag_end()

func on_tile_drag(mousePos):
	var diff = mousePos - dragged_tile.drag_start_pos

	if abs(diff.x) > abs(diff.y):
		diff.y = 0
		diff.x = clamp(diff.x, -tile_size_with_gap, tile_size_with_gap)
	else:
		diff.x = 0
		diff.y = clamp(diff.y, -tile_size_with_gap, tile_size_with_gap)

	var neighbour_index = dragged_tile.index + sign(diff)

	if is_valid_index(neighbour_index):
		dragged_tile.position = get_default_pos(dragged_tile.index) + diff
		var new_neighbour_tile = tiles[neighbour_index.x][neighbour_index.y]

		if (neighbour_tile && new_neighbour_tile != neighbour_tile):
			reset_position(neighbour_tile)

		neighbour_tile = new_neighbour_tile
		neighbour_tile.position = get_default_pos(neighbour_tile.index) - diff
	else:
		reset_position(dragged_tile)

		if neighbour_tile:
			reset_position(neighbour_tile)

func on_drag_end():
	resetting_tiles = [dragged_tile, neighbour_tile]
	dragged_tile.on_drag_end()
	dragged_tile = null
	neighbour_tile = null
	set_process_input(false)

func get_default_pos(index: Vector2) -> Vector2:
	return index * tile_size_with_gap

func reset_position(tile: Tile):
	tile.position = get_default_pos(tile.index)

func is_valid_index(index: Vector2) -> bool:
	return index.x >= 0 and index.x < columns and index.y >= 0 and index.y < rows

func _process(delta):
	animate_tile_reset(delta)

func animate_tile_reset(delta):
	if !resetting_tiles.is_empty():
		for tile in resetting_tiles:
			if !tile:
				resetting_tiles.erase(tile)
				continue

			var target = get_default_pos(tile.index)
			tile.position = tile.position.move_toward(target, tile_reset_speed * delta)

			if tile.position.distance_to(target) < 1:
				resetting_tiles.erase(tile)
				reset_position(tile)
				tile.z_index = 0
