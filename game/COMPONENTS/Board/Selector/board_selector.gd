class_name BoardSelector
extends Node2D

signal pressed(pos: Vector2i)

var _pos: Vector2i

@onready var arrow: TextureButton = $Arrow


func set_starting_position(pos: Vector2i) -> void:
	_pos = pos


func _on_texture_button_pressed() -> void:
	pressed.emit(_pos)
