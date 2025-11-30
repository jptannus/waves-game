class_name Bird
extends Node2D

var _speed: float


func set_bird_speed(speed: float) -> void:
	_speed = speed


func fly(pos: Vector2, steps: int, step_distance: float, direction: Vector2i, speed: float) -> void:
	global_position = pos
	var tweenStep: Vector2 = Vector2(0, 0)
	%Art.flip_h = false
	%Art.rotation_degrees = 0
	%FlyAudio.play()
	# Go to the right
	if direction.x == 1:
		tweenStep += Vector2(step_distance, 0)
	# Go to the left
	elif direction.x == -1:
		%Art.flip_h = true
		tweenStep += Vector2(-step_distance, 0)
	# Go to the bottom
	elif direction.y == 1:
		%Art.rotation_degrees = 90
		tweenStep += Vector2(0, step_distance)
	# Go to the top
	elif direction.y == -1:
		%Art.rotation_degrees = -90
		tweenStep += Vector2(0, -step_distance)
	visible = true
	for step in steps + 1:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", global_position + tweenStep, speed)
		tween.play()
		await tween.finished

	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "global_position", tweenStep * 10, speed)
	await tween2.finished
	visible = false


func play_ready_audio() -> void:
	%ReadyAudio.play()
