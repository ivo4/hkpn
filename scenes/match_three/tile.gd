extends Area2D

class_name Tile

signal drag_started

var index: Vector2
var color: Enums.TileColor = Enums.get_random_tile_color()

var is_dragging = false
var drag_start_pos: Vector2

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
