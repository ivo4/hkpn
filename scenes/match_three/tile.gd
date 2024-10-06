extends Area2D

class_name Tile

signal drag_started(tile: Tile)
signal movement_ended(tile: Tile)
signal disappeared(tile: Tile)

var index: Vector2
var color: Enums.TileColor = Enums.get_random_tile_color()
var icon: Enums.TileIcon = Enums.get_random_tile_icon()

var is_dragging = false
var drag_start_pos: Vector2

var is_moving = false
var moving_to: Vector2
const move_speed = 600

var is_disappearing = false
const disappear_speed = 2.4

const textureBugsprayIcon = preload("res://assets/sprites/icon-bugspray.png")
const iconScaleBugspray = 0.07

const textureZapperIcon = preload("res://assets/sprites/icon-zapper.png")
const iconScaleZapper = 0.105

const textureCreamIcon = preload("res://assets/sprites/icon-cream.png")
const iconScaleCream = 0.06

func _ready():
	match icon:
		Enums.TileIcon.SPRAY:
			$Icon.texture = textureBugsprayIcon
			$Icon.scale = Vector2(iconScaleBugspray, iconScaleBugspray)
		Enums.TileIcon.ZAPPER:
			$Icon.texture = textureZapperIcon
			$Icon.scale = Vector2(iconScaleZapper, iconScaleZapper)
		Enums.TileIcon.CREAM:
			$Icon.texture = textureCreamIcon
			$Icon.scale = Vector2(iconScaleCream, iconScaleCream)
		_:
			$Icon.queue_free()

func _on_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_dragging = true
				drag_start_pos = event.position
				drag_started.emit(self)
				z_index = 1

func on_drag_end():
	is_dragging = false

func str():
	return "Tile(" + str(index) + ")"

func _process(delta: float):
	if is_moving:
		position = position.move_toward(moving_to, move_speed * delta)

		if position == moving_to:
			is_moving = false
			movement_ended.emit(self)
			z_index = 0

	if is_disappearing:
		modulate.a -= disappear_speed * delta

		if modulate.a <= 0:
			disappeared.emit(self)
			queue_free()
