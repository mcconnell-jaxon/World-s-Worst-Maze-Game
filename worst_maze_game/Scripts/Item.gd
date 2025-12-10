extends Resource

class_name Item

signal qty_changed(new_qty: int)

@export var stats: PlayerStats 
@export var id : StringName
@export var title : String
@export var icon : Texture2D
@export_multiline var description : String
@export var effect: EffectType = EffectType.NONE
@export var amount: int = 0
@export var consumes_on_use := true

enum EffectType { NONE, HEAL, ATK, DEF, SPD, RDM }
var _qty := 0
@export var qty: int:
	get: return _qty
	set(value):
		value = max(value, 0)
		if value == _qty: return
		_qty = value
		qty_changed.emit(_qty)

# Variable types for item effect
func apply_to(stats: PlayerStats) -> String:
	match effect:
		EffectType.HEAL:
			stats.add_health(amount)
			return "Health increased by %d" % amount

		EffectType.ATK:
			stats.add_attack(amount)
			return "Attack increased by %d" % amount

		EffectType.DEF:
			stats.add_defense(amount)
			return "Defense increased by %d" % amount

		EffectType.SPD:
			stats.add_speed(amount)
			return "Speed increased by %d" % amount

		EffectType.RDM:
			# Uses up to 5 HP, but never kills the player
			var current_hp := stats.get_player_health()
			var damage := 5
			
			# Prevent HP from dropping to 0
			if current_hp - damage < 1:
				damage = current_hp - 1
				
			if damage > 0:
				stats.add_health(-damage)
				
			var rng := RandomNumberGenerator.new()
			rng.randomize()
			var boost := rng.randi_range(1, 3)
			var which := rng.randi_range(0, 2)

			var stat_name := ""
			match which:
				0:
					stats.add_attack(boost)
					stat_name = "Attack"
				1:
					stats.add_defense(boost)
					stat_name = "Defense"
				2:
					stats.add_speed(boost)
					stat_name = "Speed"
					
			# Build message using the damage dealt
			if damage > 0:
				return "You lost %d HP but %s increased by %d!" % [damage, stat_name, boost]
			else:
				return "%s increased by %d! (You were already at 1 HP.)" % [stat_name, boost]
		_:
			return ""
