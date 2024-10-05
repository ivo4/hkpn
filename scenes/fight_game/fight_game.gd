extends Node2D

signal damage(amount: float)

enum WEAPON {
	SLAP,
	GAS,
}

enum WEAPON_STATE {
	INACTIVE,
	ARMED,
	ACTIVE
}

var mosquito_scene: PackedScene = preload("res://scenes/fight_game/mosquito.tscn")
var slap_attack: PackedScene = preload("res://scenes/fight_game/attacks/slap.tscn")

var current_weapon: WEAPON = WEAPON.SLAP
var weapon_state: WEAPON_STATE = WEAPON_STATE.INACTIVE
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
		if (current_weapon == WEAPON.SLAP):
			current_attack = slap_attack.instantiate()
			#current_attack.position = event.position
			current_attack.position = get_global_mouse_position() - position
			current_attack.attack_ended.connect(_attack_ended)
			damage.emit(1)
			add_child(current_attack)


func _attack_ended() -> void:
	current_attack.queue_free()
	current_attack = null


func _spawn_mosquito(spawn_pos_x: float, target_pos: Vector2):
	var mosquito = mosquito_scene.instantiate()
	mosquito.position.x = spawn_pos_x
	#mosquito.set_target($Human.position)
	mosquito.set_target(target_pos)
	add_child(mosquito)


func _on_mosquito_spawn_timer_timeout() -> void:
	var spawn_area: Rect2 = $MosquitoSpawnArea/CollisionShape2D.shape.get_rect()
	var spawn_pos_x: float = randf_range(0, spawn_area.size.x)
	var target_area: CollisionShape2D = $TargetArea/CollisionShape2D
	var target_area_rect: Rect2 = $TargetArea/CollisionShape2D.shape.get_rect()
	var target_pos: Vector2 = Vector2(randf_range(0, target_area_rect.size.x), $TargetArea.position.y)
	_spawn_mosquito(spawn_pos_x, target_pos)


func _on_end_area_body_entered(body: Node2D) -> void:
	body.queue_free()
	damage.emit(5)
