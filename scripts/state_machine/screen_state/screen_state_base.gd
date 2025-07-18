class_name ScreenStateBase
extends Node

# 此处的State特指屏幕场景
# 见 scenes/screens

@export var music: MusicPlayer.Music

var game: SoccerGame = null
var screen_data: ScreenStateData = null


func _enter_tree() -> void:
	MusicPlayer.play_music(music)


func setup(context_game: SoccerGame, context_data: ScreenStateData) -> void:
	game = context_game
	screen_data = context_data


func transition_to_state(new_state: SoccerGame.ScreenType, data: ScreenStateData = ScreenStateData.new()) -> void:
	EventBus.screen_state_transition_requested.emit(new_state, data)
