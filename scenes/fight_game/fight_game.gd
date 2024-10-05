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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("Attack"):
		##if (current_weapon == WEAPON.SLAP):
		#print_debug("Attack started")
		#if (current_weapon == WEAPON.SLAP):
			#current_attack = slap_attack.instantiate()
			#current_attack.position = Input.
	#if Input.is_action_just_released("Attack"):
		#print_debug("Attack activated")


func _input(event: InputEvent) -> void:
	if (event.is_action("Attack")):
		if (current_attack != null):
			return
		if (current_weapon == WEAPON.SLAP):
			current_attack = slap_attack.instantiate()
			current_attack.position = event.position
			current_attack.attack_ended.connect(_attack_ended)
			add_child(current_attack)


func _attack_ended() -> void:
	current_attack.queue_free()
	current_attack = null


func _spawn_mosquito(pos_x: float):
	var mosquito = mosquito_scene.instantiate()
	mosquito.position.x = pos_x
	mosquito.set_target($Human)
	add_child(mosquito)


func _on_mosquito_spawn_timer_timeout() -> void:
	var spawn_area: Rect2 = $MosquitoSpawnArea/CollisionShape2D.shape.get_rect()
	var random_x: float = randf_range(0, spawn_area.size.x)
	_spawn_mosquito(random_x)


func _on_end_area_body_entered(body: Node2D) -> void:
	body.queue_free()
	damage.emit(5)
