class_name GameStateFactory

var states: Dictionary


func _init() -> void:
	states = {
		GameManager.State.IN_PLAY: GameStateInPlay,
		GameManager.State.SCORED: GameStateScored,
		GameManager.State.RESET: GameStateReset,
		GameManager.State.KICKOFF: GameStateKickoff,
		GameManager.State.OVERTIME: GameStateOvertime,
		GameManager.State.GAME_OVER: GameStateGameOver,
	}


func get_fresh_state(state: GameManager.State) -> GameStateBase:
	assert(states.has(state), "State not found: %s" % state)

	return states.get(state).new()