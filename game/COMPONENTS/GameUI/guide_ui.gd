extends MarginContainer

@onready var open_guide_button: Button = %OpenGuideButton
@onready var close_guide_button: TextureButton = %CloseGuideButton
@onready var guide: HBoxContainer = %Guide


func _on_open_guide_button_pressed() -> void:
	guide.visible = true
	open_guide_button.visible = false


func _on_close_guide_button_pressed() -> void:
	guide.visible = false
	open_guide_button.visible = true
