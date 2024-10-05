extends CharacterBody2D


const SPEED = 150.0

var target: Node2D

func _physics_process(_delta: float) -> void:
	'''
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	'''
	var direction: Vector2 = position.direction_to(target.position)
	velocity = direction * SPEED
	move_and_slide()

func set_target(_target: Node2D):
	target = _target
