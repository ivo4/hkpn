extends Area2D

class_name Tile

signal drag_started
signal movement_ended
signal disappeared

var index: Vector2
var color: Enums.TileColor = Enums.get_random_tile_color()

var is_dragging = false
var drag_start_pos: Vector2

var is_moving = false
var moving_to: Vector2
const move_speed = 600

var is_disappearing = false
const disappear_speed = 2.4

func _ready():
	connect("input_event", Callable(self, "_on_input_event"))

func _on_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_dragging = true
				drag_start_pos = event.position
				emit_signal("drag_started", self)
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
			emit_signal("movement_ended", self)
			z_index = 0

	if is_disappearing:
		modulate.a -= disappear_speed * delta

		if modulate.a <= 0:
			emit_signal("disappeared", self)
			queue_free()
