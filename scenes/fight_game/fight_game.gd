extends Node2D

signal damage(amount: float)
signal weapon_activated(weapon: Enums.WEAPON)


@onready var zapper: Area2D = $ZapperArea

var mosquito_scene: PackedScene = preload("res://scenes/fight_game/mosquito.tscn")
var slap_attack: PackedScene = preload("res://scenes/fight_game/attacks/slap.tscn")
var spray_attack: PackedScene = preload("res://scenes/fight_game/attacks/spray.tscn")

var current_weapon: Enums.WEAPON = Enums.WEAPON.SLAP
var current_attack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	#if not get_viewport_rect().has_point(event.position):
		#print_debug("not in viewport")
		#return
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


func _attack_ended() -> void:
	current_attack.queue_free()
	current_attack = null
	current_weapon = Enums.WEAPON.SLAP


func _spawn_mosquito(spawn_pos_x: float, target_pos: Vector2):
	var mosquito = mosquito_scene.instantiate()
	mosquito.position.x = spawn_pos_x
	#mosquito.set_target($Human.position)
	mosquito.set_target(target_pos)
	add_child(mosquito)


func _on_mosquito_spawn_timer_timeout() -> void:
	var spawn_area: Rect2 = $MosquitoSpawnArea/CollisionShape2D.shape.get_rect()
	var spawn_pos_x: float = randf_range(0, spawn_area.size.x)
	#var target_area: CollisionShape2D = $TargetArea/CollisionShape2D
	var target_area_rect: Rect2 = $TargetArea/CollisionShape2D.shape.get_rect()
	var target_pos: Vector2 = Vector2(randf_range(0, target_area_rect.size.x), $TargetArea.position.y)
	_spawn_mosquito(spawn_pos_x, target_pos)


func _on_end_area_body_entered(body: Node2D) -> void:
	body.queue_free()
	damage.emit(5)


func change_weapon_to_spray() -> void:
	print_debug("weapon changed to spray")
	current_weapon = Enums.WEAPON.SPRAY


func recharge_zapper() -> void:
	zapper.recharge()
