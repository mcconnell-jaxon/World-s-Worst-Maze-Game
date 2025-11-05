extends Area2D

var CHEESE = preload("res://Assets/Items/Cheese.tres")

func _on_body_entered(body) -> void:
	print("Cheese +1!")
	CHEESE.qty += 1
	queue_free()
