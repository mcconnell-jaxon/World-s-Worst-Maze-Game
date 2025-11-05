extends Area2D

var BEER = preload("res://Assets/Items/Beer.tres")

func _on_body_entered(body) -> void:
	print("Beer +1!")
	BEER.qty += 1
	queue_free()
