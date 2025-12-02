class_name DroppableArea
extends StaticBody2D
## DroppableArea
## 	This scene can be used to be placed in any place in the screen and it will
##	work as a possible place for draggable scenes to be placed. Any scene can be
##	draggable if it is given to the DroppableArea and is a Node2D.

## Emitted when a node is dropped in this area
signal dropped(node: Node2D)
## Emitted when the current content of this area start being dragged
signal content_dragged(node: Node2D)
## Emitted when the mouse is pressed inside the area
signal mouse_pressed(droppable_area: DroppableArea)
## Emitted when a drag n drop connected to this area has resolved 
signal drop_resolved()
## Emitted when a node is being dragged over this area. A drag that did not
## start on this area.
signal dragging_over(node: Node2D)
## Emitted when a node is being dragged out this area. A drag that did not
## start on this area.
signal dragging_out(node: Node2D)

## The node that this area is currently holding
@export var holding_node: Node2D
## If true it will show some visual elements, if false it will be transparent
@export var display_visuals: bool = false
## If true it will behave as a clickable node
@export var clickable: bool = false

var _disabled: bool = false
var _drop_only: bool = false


func _ready() -> void:
	%Sprite2D.visible = display_visuals
	%FakeButton.visible = clickable


## Returns true if is able to hold given node
func can_hold(_node: Node2D) -> bool:
	return !is_disabled() and !holding_node


## Add the given note to be holded by this area
## Returns true if it was successful and false if not.
func drop(node: Node2D) -> bool:
	var result = silent_drop(node)
	if result:
		dropped.emit(node)
	return result


## Same as drop but without emitting any signals
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
		return true
	return false


## Remove the holding node from the area and return it
## An content_dragged is emitted in a deferred way
func drag() -> Node2D:
	var node = silent_drag()
	content_dragged.emit.call_deferred(node)
	return node


## Same as drag without emitting any signals
func silent_drag() -> Node2D:
	if _drop_only:
		return null

	var node = holding_node
	holding_node = null
	return node


## Simply delete the current holding node
func delete_content() -> void:
	if holding_node:
		holding_node.queue_free()
		holding_node = null


## Returns true if holding a node
func is_holding() -> bool:
	return !!holding_node


func set_disabled(value: bool) -> void:
	_disabled = value


func is_disabled() -> bool:
	return _disabled


func resolve_drop() -> void:
	drop_resolved.emit()


## If set to true, this area will only receive nodes 
## but dragging for it will be impossible
func set_drop_only(value: bool) -> void:
	_drop_only = value


func is_drop_only() -> bool:
	return _drop_only


func is_draggin_over(node: Node2D) -> void:
	dragging_over.emit(node)
	
	
func is_draggin_out(node: Node2D) -> void:
	dragging_out.emit(node)


## Set if the area is also clickable
func set_clickable(value: bool) -> void:
	clickable = value
	%FakeButton.visible = clickable


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.pressed:
				mouse_pressed.emit(self)
