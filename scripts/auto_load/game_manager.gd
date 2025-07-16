extends Node

const GAME_DURATION = 2 * 60

enum State {IN_PLAY, SCORED, RESET, KICKOFF, OVERTIME, GAME_OVER}

var countries: Array[String] = ["FRANCE", "USA"]
var current_state: GameStateBase = null
var score: Array[int] = [0, 0]
var state_factory := GameStateFactory.new()
var time_left: float


func _ready() -> void:
	time_left = GAME_DURATION
	EventBus.game_state_transition_requested.connect(switch_state.bind())
	switch_state(State.IN_PLAY)


func switch_state(state: State, state_data: GameStateData = GameStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()

	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, state_data)
	current_state.name = "GameStateMachine: " + str(state)

	call_deferred("add_child", current_state)


func get_home_team() -> String:
	return countries[0]


func get_away_team() -> String:
	return countries[1]