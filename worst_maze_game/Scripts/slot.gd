extends Button

signal item_selected(item: Item)

@export var _item : Item:
	set(value):
		_item = value
		$Item_Name.text = _item.title

func _on_mouse_entered():
	if _item != null:
		owner.set_description(_item)

func _on_pressed() -> void:
	if _item != null:
		owner.show_use_button()
		owner.set_description(_item)
