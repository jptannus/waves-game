class_name Draggable
extends Node2D
## Draggable
## 	This scene is the one that will be dragged around when dragging is happening.
##	It is also the one that detects if it is over possible DroppableAreas.

## Emitted when the node being dragged is dropped.
signal dropped()

## This is the offset position the node being draged should 
## have relative to the mouse
@export var content_offset: Vector2 = Vector2(-64.0, -64.0)

var _dragging: bool = false
var _hovering_area: Node2D
var _holding: Node2D
var _origin: DroppableArea


func _process(_delta: float) -> void:
	if _dragging:
		# Logic to keep this following the mouse
		global_position = get_global_mouse_position()


## Start the behavior of dragging the provided node.
## An origin needs to be provided for the case where the node should 
## return to it
func start_dragging(node: Node2D, origin: DroppableArea) -> void:
	_holding = node
	_origin = origin
	node.reparent(self)
	node.position = content_offset
	_dragging = true


## Remove the node from the draggable dropping it in a valid droppable area.
## It tries to drop if over a valid area, or else it will go back to its origin.
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


## Returns true if currently dragging a node
func is_dragging() -> bool:
	return _dragging


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


func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_dragging():
		_hovering_area = body
		if body is DroppableArea and body != _origin:
			body.is_draggin_over(_holding)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if is_dragging():
		_hovering_area = null
		if body is DroppableArea and body != _origin:
			body.is_draggin_out(_holding)


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.pressed and is_dragging():
				drop()
