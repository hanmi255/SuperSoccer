extends Node

const IMPACT_PAUSE_DURATION := 100
const GAME_DURATION := 2 * 60

enum State {IN_PLAY, SCORED, RESET, KICKOFF, OVERTIME, GAME_OVER}

var current_match: Match = null
var current_state: GameStateBase = null
var player_setup: Array[String] = ["FRANCE", ""]
var state_factory := GameStateFactory.new()
var time_since_paused := 0.0
var time_left: float


func _init() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS


func _ready() -> void:
	time_left = GAME_DURATION
	EventBus.game_state_transition_requested.connect(switch_state.bind())
	EventBus.impact_received.connect(_on_impact_received.bind())


func _process(_delta: float) -> void:
	if get_tree().paused and Time.get_ticks_msec() - time_since_paused > IMPACT_PAUSE_DURATION:
		get_tree().paused = false


func switch_state(state: State, state_data: GameStateData = GameStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()

	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, state_data)
	current_state.name = "GameStateMachine: " + str(state)

	call_deferred("add_child", current_state)


func start_game() -> void:
	switch_state(State.RESET)


func increase_score(country_scored_on: String) -> void:
	current_match.increase_score(country_scored_on)
	EventBus.score_changed.emit()


func is_coop() -> bool:
	return player_setup[0] == player_setup[1]


func is_single_player() -> bool:
	return player_setup[1].is_empty()


func is_time_up() -> bool:
	return time_left <= 0


func get_home_team() -> String:
	return current_match.country_home


func get_away_team() -> String:
	return current_match.country_away


func get_winner() -> String:
	assert(not current_match.is_tied())
	return current_match.winner


func _on_impact_received(_impact_pos: Vector2, is_high_impact: bool) -> void:
	if is_high_impact:
		time_since_paused = Time.get_ticks_msec()
		get_tree().paused = true