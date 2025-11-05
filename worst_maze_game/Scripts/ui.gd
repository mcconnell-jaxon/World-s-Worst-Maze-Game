extends Control

@export var description: NinePatchRect
@export var stats: PlayerStats 
@onready var settings: Panel = $Settings
@onready var use: Button = $Inventory/Use
@onready var inventory: NinePatchRect = $Inventory
@onready var warning: Panel = $Warning
@onready var beer_qty_label: Label = $Inventory/Description/Qty  # adjust path to your "Qty" label node

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

func set_description(item: Item) -> void:
	# disconnect old item signal to avoid duplicate connections
	if current_item and current_item.qty_changed.is_connected(_on_item_qty_changed):
		current_item.qty_changed.disconnect(_on_item_qty_changed)

	current_item = item

	# connect to new item
	if not current_item.qty_changed.is_connected(_on_item_qty_changed):
		current_item.qty_changed.connect(_on_item_qty_changed)

	# draw UI
	description.find_child("Description").text = item.description
	description.find_child("Icon").texture = item.icon
	_on_item_qty_changed(item.qty)  # set initial qty & button state

func _on_item_qty_changed(new_qty: int) -> void:
	# Update qty label
	description.find_child("Qty").text = str(new_qty)
	# Or: beer_qty_label.text = str(new_qty)

	# Update Use button state
	use.disabled = new_qty <= 0
	use.text = "Use" if new_qty >= 1 else "Empty"

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

# Uses current item selected and applies the item effect  (simplified)
func _on_use_pressed() -> void:
	if current_item == null or current_item.qty <= 0:
		return

	print("\n" + current_item.title)
	print("Yummy " + current_item.title + "!")
	current_item.apply_to(stats)
	current_item.qty -= 1  # emits qty_changed; UI refreshes via _on_item_qty_changed

	if current_item.qty == 0:
		print("You have emptied this item!\n")

# Change scene to main menu scene
func _on_yes_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_no_pressed() -> void:
	warning.hide()
	inventory.show()
