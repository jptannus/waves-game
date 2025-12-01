extends Node2D

var _sfx_bus_id: int
var _bgm_bus_id: int
var _master_bus_id: int


func _ready() -> void:
	_master_bus_id = AudioServer.get_bus_index("Master")
	_bgm_bus_id = AudioServer.get_bus_index("Music")
	_sfx_bus_id = AudioServer.get_bus_index("SoundEffects")


func play_bgm() -> void:
	%BGMAudio.play()


func stop_bgm() -> void:
	%BGMAudio.stop()


func mute_all() -> void:
	AudioServer.set_bus_mute(_master_bus_id, true)


func mute_bgm() -> void:
	AudioServer.set_bus_mute(_bgm_bus_id, true)


func mute_sfx() -> void:
	AudioServer.set_bus_mute(_sfx_bus_id, true)


func unmute_all() -> void:
	AudioServer.set_bus_mute(_master_bus_id, false)


func unmute_bgm() -> void:
	AudioServer.set_bus_mute(_bgm_bus_id, false)


func unmute_sfx() -> void:
	AudioServer.set_bus_mute(_sfx_bus_id, false)
