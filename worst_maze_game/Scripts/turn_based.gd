extends Control
signal end_fight

@onready var replace_with_enemy: Label = $"MarginContainer/Replace with enemy"

func _ready() -> void:
	#replace_with_enemy.text = "This is " + enemy.enemy
	pass

func _on_action_select_end_fight() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($MarginContainer, "modulate:a", 0, 0.5).from(1)
	await get_tree().create_timer(1).timeout
	end_fight.emit()
