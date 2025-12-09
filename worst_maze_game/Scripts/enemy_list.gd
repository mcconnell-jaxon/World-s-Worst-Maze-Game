extends Resource

class_name enemyList

func get_enemy(enemy: String) -> Dictionary:
	var enemies = {
		"enemy_1": {"min_health": 10, "max_health": 15, "attacks": ["attack1", "attack2"], "damage": [4, 6], "sprite": "file location goes here"},
		"enemy_2": {"min_health": 12, "max_health": 15, "attacks": ["attack1", "attack2"], "damage": [5, 6], "sprite": "file location goes here"},
		"enemy_3": {"min_health": 20, "max_health": 30, "attacks": ["attack1", "attack2"], "damage": [7, 9], "sprite": "file location goes here"},
		"enemy_4": {"min_health": 18, "max_health": 25, "attacks": ["attack1", "attack2"], "damage": [9, 11], "sprite": "file location goes here"}}
	
	return enemies[enemy]
