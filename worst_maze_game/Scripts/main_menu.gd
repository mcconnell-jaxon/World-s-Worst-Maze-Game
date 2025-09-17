extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var about: Panel = $About
@onready var settings: Panel = $Settings

func _ready():
	main_buttons.visible = true		# Shows main menu when scene is ran
	about.visible = false		# Hides About panel
	settings.visible = false		# Hides Settings panel

func _on_start_button_pressed() -> void:		# Start button pressed will change scene to game scene
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_about_button_pressed() -> void:		# Display About panel
	main_buttons.visible = false
	about.visible = true

func _on_exit_button_pressed() -> void:		# Exits the game
	get_tree().quit()


func _on_back_button_pressed() -> void:		# Runs the ready func again
	_ready()


func _on_settings_button_pressed() -> void:		# Displays the settings menu / Hide main menu
	main_buttons.visible = false
	settings.visible = true
