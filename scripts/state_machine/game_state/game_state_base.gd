class_name GameStateBase
extends Node

var manager: GameManager = null
var state_data := GameStateData.new()


func setup(context_manager: GameManager, context_state_data: GameStateData) -> void:
	manager = context_manager
	state_data = context_state_data


func transition_state(new_state: GameManager.State, data: GameStateData = GameStateData.new()) -> void:
	EventBus.game_state_transition_requested.emit(new_state, data)