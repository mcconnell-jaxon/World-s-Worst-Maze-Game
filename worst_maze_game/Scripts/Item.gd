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
		qty_changed.emit(_qty)  # <<— tell listeners the count changed

# Variable types for item effect
func apply_to(stats: PlayerStats) -> void:
	match effect:
		EffectType.HEAL:
			stats.add_health(amount)
		EffectType.ATK:
			stats.add_attack(amount)
		EffectType.DEF:
			stats.add_defense(amount)
		EffectType.SPD:
			stats.add_speed(amount)
		# Random Effect Generator
		EffectType.RDM:
			stats.add_health(-5)
			var rng := RandomNumberGenerator.new()
			rng.randomize()
			# Random number generator for buff 1-3+
			var boost := rng.randi_range(1, 3)
			# Random number generator for a stat
			var which := rng.randi_range(0, 2)
			match which:
				# 0=ATK, 1=DEF, 2=SPD
				0: stats.add_attack(boost)
				1: stats.add_defense(boost)
				2: stats.add_speed(boost)
		_:
			pass
