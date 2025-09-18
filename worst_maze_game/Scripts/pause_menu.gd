extends Control

@onready var settings: Panel = $Settings
@onready var pause_buttons: VBoxContainer = $PanelContainer/PauseButtons

func _ready() -> void:
	settings.hide()		# Hides settings button when scene is played
	pause_buttons.hide()		# Hides pause menu when scene is played

func _process(delta):
	testEsc()		# Registering Esc input

func resume():		# Function to proceed game / hide pause menu
	get_tree().paused = false
	settings.hide()
	pause_buttons.hide()
	$AnimationPlayer.play_backwards("blur")		# Animation for smooth pause menu

func pause():		# Function to pause all process and show pause menu
	get_tree().paused = true
	settings.hide()
	pause_buttons.show()
	$AnimationPlayer.play("blur")

func testEsc():		# Function to detect Esc input
	if Input.is_action_just_pressed("Escape"):
		if get_tree().paused:
			if settings.visible:	# Allow Esc input to hide settings menu / Backtrack to pause menu
				settings.hide()
				pause_buttons.show()
			else:
				resume()		# Resumes game when Esc is pressed when paused
		else:
			pause()		# Pauses game when Esc is pressed

func _on_resume_button_pressed() -> void:
	resume()

func _on_return_button_pressed() -> void:		# Function changes scene to main menu
	resume()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_settings_button_pressed() -> void:
	pause_buttons.hide()
	settings.show()

func _on_back_button_pressed() -> void:
	settings.hide()
	pause_buttons.show()
