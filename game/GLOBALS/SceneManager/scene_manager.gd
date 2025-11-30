extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Transition/AnimationPlayer
@onready var full_color: ColorRect = $Transition/FullColor

# List of scenes to call
const MAIN_MENU = preload("uid://c8fshbmgebic0")
const SETTINGS = preload("uid://cven3fatop5le")
const GAME_OVER = preload("uid://d3o0ylb6i1bag")
const GAME = preload("uid://8224asd1jqmf")

# Functions
func change_scene(scene:PackedScene) -> void:
	# Fade in
	animation_player.play("transition_start")
	full_color.mouse_filter = Control.MOUSE_FILTER_STOP
	await(animation_player.animation_finished)
	#Fade out
	get_tree().change_scene_to_packed(scene)
	animation_player.play("transition_end")
	full_color.mouse_filter = Control.MOUSE_FILTER_IGNORE
	# NOTE: Added the mouse filter to avoid fast-clicking issues. There are probably much better ways to fix this.
