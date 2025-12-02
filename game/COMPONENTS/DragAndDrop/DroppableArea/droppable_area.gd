class_name DroppableArea
extends StaticBody2D
## DroppableArea
## 	This scene can be used to be placed in any place in the screen and it will
##	work as a possible place for draggable scenes to be placed. Any scene can be
##	draggable if it is given to the DroppableArea and is a Node2D.

signal dropped(node: Node2D)
signal content_dragged(node: Node2D)
signal mouse_pressed(droppable_area: DroppableArea)
signal drop_resolved()
signal dragging_over(node: Node2D)
signal dragging_out(node: Node2D)

@export var holding_node: Node2D
@export var display_visuals: bool = false
@export var clickable: bool = false

var _disabled: bool = false
var _drop_only: bool = false


func _ready() -> void:
	%Sprite2D.visible = display_visuals
	%FakeButton.visible = clickable


func can_hold(_node: Node2D) -> bool:
	return !is_disabled() and !holding_node


func drop(node: Node2D) -> bool:
	var result = silent_drop(node)
	if result:
		dropped.emit(node)
	return result


func silent_drop(node: Node2D) -> bool:
	if is_disabled():
		return false

	if !holding_node:
		holding_node = node
		if node.get_parent():
			node.reparent(self)
		else:
			add_child(node)
		node.position = Vector2(0, 0)
		_update_display()
		return true
	return false


func drag() -> Node2D:
	var node = silent_drag()
	content_dragged.emit.call_deferred(node)
	return node


func silent_drag() -> Node2D:
	if _drop_only:
		return null

	var node = holding_node
	holding_node = null
	_update_display()
	return node


func delete_content() -> void:
	if holding_node:
		holding_node.queue_free()
		holding_node = null
		_update_display()


func is_holding() -> bool:
	return !!holding_node


func disable() -> void:
	_disabled = true


func enable() -> void:
	_disabled = true


func is_disabled() -> bool:
	return _disabled


func resolve_drop() -> void:
	drop_resolved.emit()


func set_drop_only(value: bool) -> void:
	_drop_only = value


func is_drop_only() -> bool:
	return _drop_only


func is_draggin_over(node: Node2D) -> void:
	dragging_over.emit(node)
	
	
func is_draggin_out(node: Node2D) -> void:
	dragging_out.emit(node)


func set_clickable(value: bool) -> void:
	clickable = value
	%FakeButton.visible = clickable


func _update_display() -> void:
	pass


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.pressed:
				mouse_pressed.emit(self)
