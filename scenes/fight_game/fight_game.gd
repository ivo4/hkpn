extends Node2D

signal damage(amount: float)
signal weapon_activated(weapon: Enums.WEAPON)
signal mosquito_burned

@onready var zapper: Area2D = $ZapperArea

var mosquito_scene: PackedScene = preload("res://scenes/fight_game/mosquito.tscn")
var slap_attack: PackedScene = preload("res://scenes/fight_game/attacks/slap.tscn")
var spray_attack: PackedScene = preload("res://scenes/fight_game/attacks/spray.tscn")
var flame_attack: PackedScene = preload("res://scenes/fight_game/attacks/flame.tscn")

var boy_sprite1: Texture = preload("res://assets/characters/boy-1.png")
var boy_sprite2: Texture = preload("res://assets/characters/boy-2.png")
var boy_sprite3: Texture = preload("res://assets/characters/boy-3.png")

var current_weapon: Enums.WEAPON = Enums.WEAPON.SLAP
var current_attack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("Attack")):
		if (current_attack != null):
			return
		if (current_weapon == Enums.WEAPON.SLAP):
			current_attack = slap_attack.instantiate()
			current_attack.position = get_global_mouse_position() - position
			current_attack.attack_ended.connect(_attack_ended)
			damage.emit(1)
			add_child(current_attack)
			weapon_activated.emit(Enums.WEAPON.SLAP)
		if (current_weapon == Enums.WEAPON.SPRAY):
			current_attack = spray_attack.instantiate()
			current_attack.position = get_global_mouse_position() - position
			current_attack.attack_ended.connect(_attack_ended)
			add_child(current_attack)
			weapon_activated.emit(Enums.WEAPON.SPRAY)
		if (current_weapon == Enums.WEAPON.FLAME):
			current_attack = flame_attack.instantiate()
			current_attack.position = $Human.position
			current_attack.attack_ended.connect(_attack_ended)
			current_attack.mosquito_burned.connect(_mosquito_burned)
			add_child(current_attack)
			weapon_activated.emit(Enums.WEAPON.FLAME)


func _attack_ended() -> void:
	print_debug("attack_ended")
	current_attack.queue_free()
	current_attack = null
	current_weapon = Enums.WEAPON.SLAP


func _mosquito_burned() -> void:
	mosquito_burned.emit()


func _spawn_mosquito(spawn_pos_x: float, target_pos: Vector2):
	var mosquito = mosquito_scene.instantiate()
	mosquito.position.x = spawn_pos_x
	#mosquito.set_target($Human.position)
	mosquito.set_target(target_pos)
	add_child(mosquito)


func _on_initial_delay_timer_timeout() -> void:
	$InitialDelayTimer.stop()
	$MosquitoSpawnTimer.start()


func _on_mosquito_spawn_timer_timeout() -> void:
	var spawn_area: Rect2 = $MosquitoSpawnArea/CollisionShape2D.shape.get_rect()
	var spawn_pos_x: float = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)

	var target_pos = get_human_target_pos()

	if zapper.zapper_charge:
		target_pos = zapper.position

	_spawn_mosquito(spawn_pos_x, target_pos)


func get_human_target_pos() -> Vector2:
	var target_area_rect: Rect2 = $TargetArea/CollisionShape2D.shape.get_rect()

	return Vector2(
		randf_range(
			target_area_rect.position.x,
			target_area_rect.position.x + target_area_rect.size.x,
		),
		$TargetArea.position.y,
	)


func _on_end_area_body_entered(body: Node2D) -> void:
	body.queue_free()
	damage.emit(5)


func change_weapon_to_spray() -> void:
	print_debug("weapon changed to spray")
	current_weapon = Enums.WEAPON.SPRAY


func change_weapon_to_flame() -> void:
	print_debug("weapon changed to flame")
	current_weapon = Enums.WEAPON.FLAME


func recharge_zapper() -> void:
	zapper.recharge()

	for child in get_children():
		if child is Mosquito:
			child.set_target(zapper.position)


func _on_zapper_depleted() -> void:
	for child in get_children():
		if child is Mosquito:
			child.set_target(get_human_target_pos())


func update_annoyance(value: float) -> void:
	if value >= 66:
		$Human/HumanSprite.texture = boy_sprite3
	elif value >= 33:
		$Human/HumanSprite.texture = boy_sprite2
	else:
		$Human/HumanSprite.texture = boy_sprite1
