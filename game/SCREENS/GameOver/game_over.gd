extends Control

func _ready() -> void:
	%ScoreValue.text = str(ScoreSystem.get_score())
	%TadaSound.play()


func _on_play_again_button_pressed() -> void:
	%ButtonClickSound.play()
	SceneManager.change_scene(SceneManager.GAME)


func _on_main_menu_button_pressed() -> void:
	%ButtonClickSound.play()
	SceneManager.change_scene(SceneManager.MAIN_MENU)
