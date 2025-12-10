extends Resource

class_name PlayerStats

@export var playerName: String = ""
@export var playerHealth: int = 0
@export var maxHealth: int = 100
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

# Function to add stats (HP, ATK, DEF, SPD)
#--------------------------------------------------------
func add_health(n: int) -> void:
	playerHealth = clamp(playerHealth + n, 0, maxHealth)
	print("Player health changed to: ", playerHealth)
	emit_changed()
	
func add_attack(n: int) -> void:
	playerAttack += n
	print("Player attack changed to: ", playerAttack)
	emit_changed()
	
func add_defense(n: int) -> void:
	playerDefense += n
	print("Player defense changed to: ", playerDefense)
	emit_changed()
	
func add_speed(n: int) -> void:
	playerSpeed += n
	print("Player speed changed to: ", playerSpeed)
	emit_changed()
#--------------------------------------------------------
