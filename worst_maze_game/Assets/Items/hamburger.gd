extends Area2D

var HAMBURGER = preload("res://Assets/Items/Hamburger.tres")

func _on_body_entered(body) -> void:
	print("Hamburger +1!")
	HAMBURGER.qty += 1
	queue_free()
