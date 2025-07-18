class_name ScreenStateBase
extends Node

var game: SoccerGame = null
var screen_data: ScreenStateData = null


func setup(context_game: SoccerGame, context_data: ScreenStateData) -> void:
	game = context_game
	screen_data = context_data


func transition_to_state(new_state: SoccerGame.ScreenType, data: ScreenStateData = ScreenStateData.new()) -> void:
	EventBus.screen_state_transition_requested.emit(new_state, data)
