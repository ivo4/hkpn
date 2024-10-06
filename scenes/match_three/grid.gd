extends Area2D

@export var tile_scene: PackedScene

signal matched(count: int, color: Enums.TileColor)
signal icon_collected(icon: Enums.TileIcon)

const rows: int = 7
const columns: int = 7
const tile_size: int = 64
const gap: int = 6
const tile_size_with_gap: int = tile_size + gap

var tiles = []
var dragged_tile: Tile
var neighbour_tile: Tile
var animation_count: int = 0

func _ready():
	tiles.resize(columns)

	for x in range(columns):
		tiles[x] = []
		tiles[x].resize(rows)

		for y in range(rows):
			add_tile(x, y)

	self.call_deferred("check_for_matches")

func add_tile(x: int, y: int):
	var tile: Tile = tile_scene.instantiate()
	tile.index = Vector2(x, y)
	reset_position(tile)
	tile.connect("drag_started", Callable(self, "_on_tile_drag_started"))
	tile.connect("movement_ended", Callable(self, "_on_tile_movement_ended"))
	tile.connect("disappeared", Callable(self, "_on_tile_disappeared"))
	add_child(tile)
	tiles[x][y] = tile
	return tile

func _on_tile_drag_started(tile: Tile):
	if !animation_count:
		dragged_tile = tile
		set_process_input(true)

func _on_tile_movement_ended(_tile: Tile):
	animation_count -= 1

	if !animation_count:
		check_for_matches()

func _on_tile_disappeared(tile: Tile):
	animation_count -= 1
	tiles[tile.index.x][tile.index.y] = null

	if !animation_count:
		fill_empty_spaces()

func _input(event):
	if dragged_tile:
		if event is InputEventMouseMotion:
			on_tile_drag(event.position)

		if event is InputEventMouseButton:
			if !event.pressed:
				on_drag_end(event.position)

func on_tile_drag(mouse_pos: Vector2):
	var diff: Vector2 = get_drag_diff(mouse_pos)
	var new_neighbour_tile = get_drag_neighbour(diff)

	if new_neighbour_tile:
		dragged_tile.position = get_default_pos(dragged_tile.index) + diff

		if (neighbour_tile && new_neighbour_tile != neighbour_tile):
			reset_position(neighbour_tile)

		neighbour_tile = new_neighbour_tile
		neighbour_tile.position = get_default_pos(neighbour_tile.index) - diff
	else:
		reset_position(dragged_tile)

		if neighbour_tile:
			reset_position(neighbour_tile)

func get_drag_diff(mouse_pos: Vector2) -> Vector2:
	var diff: Vector2 = mouse_pos - dragged_tile.drag_start_pos

	if abs(diff.x) > abs(diff.y):
		diff.y = 0
		diff.x = clamp(diff.x, -tile_size_with_gap, tile_size_with_gap)
	else:
		diff.x = 0
		diff.y = clamp(diff.y, -tile_size_with_gap, tile_size_with_gap)

	return diff

func get_drag_neighbour(diff: Vector2) -> Tile:
	var neighbour_index = dragged_tile.index + sign(diff)

	if is_valid_index(neighbour_index):
		return tiles[neighbour_index.x][neighbour_index.y]
	else:
		return null

func start_movement(tile: Tile):
	tile.moving_to = get_default_pos(tile.index)
	tile.is_moving = true
	animation_count += 1

func on_drag_end(mouse_pos: Vector2):
	var diff = get_drag_diff(mouse_pos)

	if (get_drag_neighbour(diff) && diff.length() > tile_size_with_gap * 0.5):
		swap_tiles()

		if find_matches().is_empty():
			# Swap back
			swap_tiles()

	start_movement(dragged_tile)

	if neighbour_tile:
		start_movement(neighbour_tile)

	dragged_tile.on_drag_end()
	dragged_tile = null
	neighbour_tile = null
	set_process_input(false)

func swap_tiles():
	var temp_index = dragged_tile.index
	dragged_tile.index = neighbour_tile.index
	neighbour_tile.index = temp_index

	tiles[dragged_tile.index.x][dragged_tile.index.y] = dragged_tile
	tiles[neighbour_tile.index.x][neighbour_tile.index.y] = neighbour_tile

func get_default_pos(index: Vector2) -> Vector2:
	return index * tile_size_with_gap

func reset_position(tile: Tile):
	tile.position = get_default_pos(tile.index)

func is_valid_index(index: Vector2) -> bool:
	return index.x >= 0 and index.x < columns and index.y >= 0 and index.y < rows

func check_for_matches():
	var matches = find_matches()

	for tileMatch in matches:
		var count = tileMatch.size()
		var color = tileMatch[0].color
		matched.emit(count, color)

		# TODO remove
		print("Matched ", count, " ", Enums.color_to_string(color))

		for tile in tileMatch:
			tile.is_disappearing = true
			animation_count += 1

			if tile.icon != Enums.TileIcon.NONE:
				icon_collected.emit(tile.icon)

	# TODO if no matches, check whether any matches are possible to make.
	# If not, shuffle the board? Or game over.

func find_matches():
	var matches = []

	for x in range(columns):
		var color = tiles[x][0].color
		var start = 0
		var length = 1

		for y in range(1, rows):
			var tile = tiles[x][y]

			if tile.color == color:
				length += 1

			if tile.color != color || y == rows - 1:
				if length >= 3:
					var tileMatch = create_vertical_match(x, start, length)
					add_to_matches(matches, tileMatch)

				color = tile.color
				start = y
				length = 1

	for y in range(rows):
		var color = tiles[0][y].color
		var start = 0
		var length = 1

		for x in range(1, columns):
			var tile = tiles[x][y]

			if tile.color == color:
				length += 1

			if tile.color != color || x == columns - 1:
				if length >= 3:
					var tileMatch = create_horizontal_match(start, y, length)
					add_to_matches(matches, tileMatch)

				color = tile.color
				start = x
				length = 1

	return matches

func create_vertical_match(x: int, y: int, length: int):
	var match_tiles = []

	for i in range(length):
		match_tiles.append(tiles[x][y + i])

	return match_tiles

func create_horizontal_match(x: int, y: int, length: int):
	var match_tiles = []

	for i in range(length):
		match_tiles.append(tiles[x + i][y])

	return match_tiles

func add_to_matches(matches: Array, newMatch: Array):
	for existingMatch in matches:
		if matches_overlap(existingMatch, newMatch):
			merge_matches(existingMatch, newMatch)
			return

	matches.append(newMatch)

func matches_overlap(match1: Array, match2: Array) -> bool:
	for tile in match1:
		if match2.has(tile):
			return true

	return false

func merge_matches(existingMatch: Array, newMatch: Array):
	for tile in newMatch:
		if !existingMatch.has(tile):
			existingMatch.append(tile)

func fill_empty_spaces():
	for x in range(columns):
		var shift = 0

		for y in range(rows - 1, -1, -1):
			if !tiles[x][y]:
				shift += 1
			elif shift:
				var tile = tiles[x][y]
				tile.index.y += shift
				tiles[x][tile.index.y] = tiles[x][y]
				tiles[x][y] = null
				start_movement(tile)

		for y in range(shift):
			var tile = add_tile(x, y)
			tile.position += Vector2(0, -shift * tile_size_with_gap)
			start_movement(tile)
