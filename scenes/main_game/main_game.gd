extends Node2D


@onready var fight_game: Node2D = $SubViewportContainer2/SubViewport/FightGame
@onready var match_three_game: Node2D = $SubViewportContainer/SubViewport/MatchThree

@onready var annoyance_meter: Node2D = $AnnoyanceMeter

@onready var spray_powerup: Node2D = $SprayPowerupButton
@onready var zapper_powerup: Node2D = $ZapperPowerupButton
@onready var cream_powerup: Node2D = $SoothingCreamPowerupButton
@onready var flame_powerup: Node2D = $FlamePowerupButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_fight_game_damage(amount: float) -> void:
	annoyance_meter.deal_damage(amount)


func _on_spray_powerup_button_powerup_activated() -> void:
	fight_game.change_weapon_to_spray()


func _on_zapper_powerup_button_powerup_activated() -> void:
	fight_game.recharge_zapper()
	zapper_powerup.reset_value()


func _on_soothing_cream_powerup_button_powerup_activated() -> void:
	annoyance_meter.recover_damage(20)
	cream_powerup.reset_value()


func _on_fight_game_weapon_activated(weapon: Enums.WEAPON) -> void:
	print_debug("weapon activated, ", weapon)
	if (weapon == Enums.WEAPON.SPRAY):
		spray_powerup.reset_value()
	if (weapon == Enums.WEAPON.FLAME):
		flame_powerup.reset_value()


func _on_flame_powerup_button_powerup_activated() -> void:
	fight_game.change_weapon_to_flame()


func _on_match_three_matched(count: int, _color: Enums.TileColor) -> void:
	if count > 3:
		flame_powerup.increase_value(count)


# TODO connect in scene
func _on_match_three_icon_collected(icon: Enums.TileIcon) -> void:
	if icon == Enums.TileIcon.SPRAY:
		spray_powerup.increase_value(1)
	elif icon == Enums.TileIcon.ZAPPER:
		zapper_powerup.increase_value(1)
