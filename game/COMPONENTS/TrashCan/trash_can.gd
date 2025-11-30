extends Node2D


@export var animation_duration: float = 0.3



func _on_dropable_area_dropped(node: Node2D) -> void:
	%DropableArea.drag() # Ignore the return
	trash_node(node)


func trash_node(node: Node2D) -> void:
	node.reparent(self)
	var tween = get_tree().create_tween()
	tween.tween_property(node, "rotation", 2, animation_duration)
	tween.parallel().tween_property(node, "scale", Vector2(0,0), animation_duration)
	tween.parallel().tween_property(node, "position", Vector2(64,64), animation_duration)
	tween.tween_callback(node.queue_free)
	tween.play()
