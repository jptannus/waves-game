# Draggable
# 	This scene is the one that will be dragged around when dragging is happening.
#	It is also the one that detects if it is over possible DroppableAreas.
class_name Draggable
extends Node2D

signal dropped()

@export var content_offset_x: float = -64.0
@export var content_offset_y: float = -64.0

var _dragging: bool = false
var _hovering_area: Node2D
var _holding: Node2D
var _origin: DroppableArea


func _process(_delta: float) -> void:
	if _dragging:
		# Logic to keep this following the mouse
		global_position = get_global_mouse_position()


func start_dragging(node: Node2D, origin: DroppableArea) -> void:
	_holding = node
	_origin = origin
	node.reparent(self)
	node.position = Vector2(content_offset_x, content_offset_y)
	_dragging = true
	


func drop() -> Node2D:
	var place: Node2D = null
	# If there is a hovering area we try that
	if _can_drop_to(_hovering_area):
		place = _hovering_area
		_drop_to(_hovering_area)
	# If not we try the area of origin
	elif _can_drop_to(_origin):
		place = _origin
		_drop_to(_origin)
	# If not we just delete the node we are carrying
	else:
		_holding.queue_free()
		_drop_to(null)
	return place


func _can_drop_to(node: Node2D) -> bool:
	if node and node is DroppableArea:
		if node.can_hold(_holding):
			return true
	return false


func _drop_to(node: DroppableArea) -> void:
	if node:
		node.drop(_holding)
	_stop_dragging()
	dropped.emit()
	
	
func _stop_dragging() -> void:
	_holding = null
	_origin = null
	_dragging = false


func is_dragging() -> bool:
	return _dragging


func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_dragging():
		_hovering_area = body
	
	
func _on_area_2d_body_exited(_body: Node2D) -> void:
	if is_dragging():
		_hovering_area = null


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.pressed and is_dragging():
				drop()
