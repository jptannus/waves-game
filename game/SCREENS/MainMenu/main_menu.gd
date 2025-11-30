extends Control

@onready var how_to_play_modal: MarginContainer = %HowToPlayModal


func _on_start_game_button_pressed() -> void:
	%ButtonClickAudio.play()
	SceneManager.change_scene(SceneManager.GAME)


func _on_options_game_button_pressed() -> void:
	%ButtonClickAudio.play()
	SceneManager.change_scene(SceneManager.SETTINGS)


func _on_quit_button_pressed() -> void:
	%ButtonClickAudio.play()
	get_tree().quit()


func _on_how_to_play_button_pressed() -> void:
	how_to_play_modal.visible = true


func _on_close_modal_button_pressed() -> void:
	how_to_play_modal.visible = false
