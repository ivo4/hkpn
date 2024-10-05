extends CharacterBody2D

const SPEED = 150.0

var target: Node2D

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = position.direction_to(target.position)
	velocity = direction * SPEED
	move_and_slide()


func set_target(_target: Node2D):
	target = _target
