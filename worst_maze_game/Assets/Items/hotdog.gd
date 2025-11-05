extends Area2D

var HOTDOG = preload("res://Assets/Items/Hotdog.tres")

func _on_body_entered(body) -> void:
	print("Hotdog +1!")
	HOTDOG.qty += 1
	queue_free()
