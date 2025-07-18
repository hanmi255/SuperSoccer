class_name SoccerGame
extends Node

enum ScreenType {MAIN_MENU, TEAM_SELECTION, TOURNAMENT, IN_GAME}

var current_state: ScreenStateBase = null
var state_factory := ScreenStateFactory.new()


func _init() -> void:
	switch_state(ScreenType.MAIN_MENU)


func _ready() -> void:
	EventBus.screen_state_transition_requested.connect(switch_state.bind())


func switch_state(state: ScreenType, state_data: ScreenStateData = ScreenStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()

	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, state_data)
	current_state.name = "ScreenStateMachine: " + str(state)

	call_deferred("add_child", current_state)