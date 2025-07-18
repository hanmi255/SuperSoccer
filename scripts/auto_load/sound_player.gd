extends Node

enum Sound {BOUNCE, HURT, PASS, POWER_SHOOT, SHOOT, TACKLING, UI_NAV, UI_SELECT, WHISTLE}

const NUM_CHANNELS := 4
const SFX_MAP: Dictionary[Sound, AudioStream] = {
	Sound.BOUNCE: preload("res://assets/audio/sfx/bounce.wav"),
	Sound.HURT: preload("res://assets/audio/sfx/hurt.wav"),
	Sound.PASS: preload("res://assets/audio/sfx/pass.wav"),
	Sound.POWER_SHOOT: preload("res://assets/audio/sfx/power-shot.wav"),
	Sound.SHOOT: preload("res://assets/audio/sfx/shoot.wav"),
	Sound.TACKLING: preload("res://assets/audio/sfx/tackle.wav"),
	Sound.UI_NAV: preload("res://assets/audio/sfx/ui-navigate.wav"),
	Sound.UI_SELECT: preload("res://assets/audio/sfx/ui-select.wav"),
	Sound.WHISTLE: preload("res://assets/audio/sfx/whistle.wav")
}

var stream_players: Array[AudioStreamPlayer] = []


func _ready() -> void:
	for i in range(NUM_CHANNELS):
		var stream_player := AudioStreamPlayer.new()
		stream_player.name = "StreamPlayer_" + str(i)
		add_child(stream_player)
		stream_players.append(stream_player)


func play(sound: Sound) -> void:
	var player = _find_first_available_player()
	if not player:
		return

	player.stream = SFX_MAP[sound]
	player.play()


func _find_first_available_player() -> AudioStreamPlayer:
	for player in stream_players:
		if not player.is_playing():
			return player
	return null
