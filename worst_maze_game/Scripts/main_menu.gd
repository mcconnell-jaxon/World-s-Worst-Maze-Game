extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var about: Panel = $About

func _ready():
	main_buttons.visible = true
	about.visible = false

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_about_button_pressed() -> void:
	print("About clicked!")
	main_buttons.visible = false
	about.visible = true

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	_ready()
