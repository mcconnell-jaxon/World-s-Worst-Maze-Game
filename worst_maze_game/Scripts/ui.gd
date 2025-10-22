extends Control

@export var description: NinePatchRect
@export var stats: PlayerStats 
@onready var settings: Panel = $Settings
@onready var use: Button = $Inventory/Use
@onready var inventory: NinePatchRect = $Inventory
@onready var warning: Panel = $Warning

var current_item: Item = null 

# When game scene runs, UI is hidden
func _ready() -> void:
	if stats == null:
		stats = load("res://resources/player_stats.tres")
	use.hide()
	warning.hide()
	settings.hide()
	inventory.hide()

# Pauses(physics) game scene and show inventory
func paused() -> void:
	get_tree().paused = true
	inventory.show()

# Unpauses game scene and hide all UI
func resume() -> void:
	get_tree().paused = false
	inventory.hide()

# Uses the variable of the item to display desc, icon, qty
func set_description(item: Item) -> void:
	current_item = item
	description.find_child("Description").text = item.description
	description.find_child("Icon").texture = item.icon
	description.find_child("Qty").text = str(item.qty)
	# Check if qty is above 1; Enable use button
	if current_item.qty >= 1:
		use.disabled = false
		use.text = "Use"
	# Check if qty is below 1; Disable use button
	if current_item.qty <= 0:
		use.disabled = true
		use.text  = "Empty"

# Check for Escape keybind
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):  # Esc
		if get_tree().paused:
			resume()
		else:
			paused()

# Display Use button
func show_use_button() -> void:
	use.show()

# Display Inventory UI
func _on_settings_button_pressed() -> void:
	inventory.hide()
	settings.show()
	
# Pop up Warning panel
func _on_return_button_pressed() -> void:
	warning.show()
	inventory.hide()

func _on_back_button_pressed() -> void:
	settings.hide()
	inventory.show()

# Uses current item selected and applies the item effect
func _on_use_pressed() -> void:
	print("\n" + current_item.title)
	if current_item == null:
		return
	
	# Uses item and apply item effect
	if current_item.qty == 1:
		print("Yummy " + current_item.title + "!")
		current_item.apply_to(stats)
		current_item.qty-= 1
		set_description(current_item)
		print("You have emptied this item!\n")
		
	# Uses item and apply item effect
	if current_item.qty > 0:
		print("Yummy " + current_item.title + "!")
		current_item.apply_to(stats)
		current_item.qty -= 1
		# Updates Qty change
		set_description(current_item)
		
	# If Qty is Zero, Use button is disabled
	if current_item.qty <= 0:
		use.disabled = true
		use.text = "Empty"
		
# Change scene to main menu scene
func _on_yes_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_no_pressed() -> void:
	warning.hide()
	inventory.show()
