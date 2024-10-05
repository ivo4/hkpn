extends Node2D

signal damage(amount: float)

enum WEAPON_STATE {
	SLAP,
	GAS,
}

var mosquito_scene: PackedScene = preload("res://scenes/fight_game/mosquito.tscn")

var current_weapon: WEAPON_STATE = WEAPON_STATE.SLAP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if (event.is_action("Attack")):
		if (current_weapon == WEAPON_STATE.SLAP):
			print_debug(event)


func _spawn_mosquito(pos_x):
	var mosquito = mosquito_scene.instantiate()
	mosquito.position.x = pos_x
	mosquito.set_target($Human)
	add_child(mosquito)


func _on_mosquito_spawn_timer_timeout() -> void:
	var spawn_area: Rect2 = $MosquitoSpawnArea/CollisionShape2D.shape.get_rect()
	var random_x: int = randi_range(0, spawn_area.size.x)
	_spawn_mosquito(random_x)


func _on_end_area_body_entered(body: Node2D) -> void:
	body.queue_free()
	damage.emit(5)
