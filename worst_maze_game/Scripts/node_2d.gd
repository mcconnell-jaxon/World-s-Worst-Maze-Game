extends Node2D
@onready var rich_text_label: RichTextLabel = $RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rich_text_label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(_body: Node2D) -> void:
	rich_text_label.visible = true
	await get_tree().create_timer(3.0).timeout
	if rich_text_label.visible == true:
		get_tree().quit()
	
