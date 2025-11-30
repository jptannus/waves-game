class_name BoardSelector
extends Node2D

@onready var arrow: TextureButton = $Arrow

signal pressed(pos: Vector2i)

var _pos: Vector2i


func set_starting_position(pos: Vector2i) -> void:
	_pos = pos


func _on_texture_button_pressed() -> void:
	pressed.emit(_pos)
