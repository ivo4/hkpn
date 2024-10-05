extends CharacterBody2D

const SPEED = 30.0

var target_pos: Vector2

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = position.direction_to(target_pos)
	velocity = direction * SPEED
	move_and_slide()


func set_target(_target_pos: Vector2):
	target_pos = _target_pos
