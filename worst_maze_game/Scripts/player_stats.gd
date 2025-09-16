extends Resource

class_name PlayerStats

@export var playerName: String = ""
@export var playerHealth: int = 0
@export var playerAttack: int = 0
@export var playerDefense: int = 0
@export var playerSpeed: int = 0

func set_player_name(name):
	playerName = name

func get_player_name() -> String:
	return "%s" % [playerName]

func get_player_health() -> int:
	return playerHealth

func get_player_attack() -> int:
	return playerAttack

func get_player_defense() -> int:
	return playerDefense

func get_player_speed() -> int:
	return playerSpeed
