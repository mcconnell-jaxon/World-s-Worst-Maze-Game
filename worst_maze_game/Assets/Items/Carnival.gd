extends Area2D

var CARNIVAL = preload("res://Assets/Items/Carnival.tres")

func _on_body_entered(body) -> void:
	print("Carnival +1!")
	CARNIVAL.qty += 1
	queue_free()
