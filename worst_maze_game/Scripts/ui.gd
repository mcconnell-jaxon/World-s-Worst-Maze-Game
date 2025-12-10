extends Control

signal item_message(text: String)
signal inventory_closed()

@export var description: NinePatchRect
@export var stats: PlayerStats 
@onready var settings: Panel = $Settings
@onready var use: Button = $Inventory/Use
@onready var inventory: NinePatchRect = $Inventory
@onready var warning: Panel = $Warning
@onready var beer_qty_label: Label = $Inventory/Description/Qty  # adjust path to your "Qty" label node

var current_item: Item = null 
# Safety measure to prevent unpausing when in turn_based scene
var esc_enabled: bool = true

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
		if esc_enabled == false:
			print("No")
			return
		else:
			if esc_enabled == true:
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
	if current_item == null or current_item.qty <= 0:
		return
		
	# Apply item and get a description of changes
	var stat_msg: String = current_item.apply_to(stats)
	current_item.qty -= 1
	# Building msg -------------------------------------------------
	var msg := "Yummy %s!" % current_item.title

	if stat_msg != "":
		msg += "\n" + stat_msg
	msg += "\nPlayer health changed to: %d" % int(stats.get_player_health())
	if current_item.qty == 0:
		msg += "\nYou have emptied this item!"
	#----------------------------------------------------------------
	# Signal to send msg to turn_based.gd
	item_message.emit(msg)
	inventory_closed.emit()		# Closes the inventory after uses an item
	
# Change scene to main menu scene
func _on_yes_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_no_pressed() -> void:
	warning.hide()
	inventory.show()
