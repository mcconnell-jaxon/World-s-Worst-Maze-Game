extends Control

@export var description: NinePatchRect

@onready var settings: Panel = $Settings
@onready var use: Button = $Inventory/Use
@onready var inventory: NinePatchRect = $Inventory

func _ready() -> void:
	use.hide()
	settings.hide()
	inventory.hide()

func paused() -> void:
	get_tree().paused = true
	inventory.show()

func resume() -> void:
	get_tree().paused = false
	inventory.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):  # Esc
		if get_tree().paused:
			resume()
		else:
			paused()
		get_viewport().set_input_as_handled()

func set_description(item: Item) -> void:
	description.find_child("Description").text = item.description
	description.find_child("Icon").texture = item.icon

func show_use_button() -> void:
	use.show()

func _on_settings_button_pressed() -> void:
	inventory.hide()
	settings.show()

func _on_return_button_pressed() -> void:		# Function changes scene to main menu
	resume()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_back_button_pressed() -> void:
	settings.hide()
	inventory.show()
