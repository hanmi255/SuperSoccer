extends Node

const IMPACT_PAUSE_DURATION := 100
const GAME_DURATION := 2 * 60

enum State {IN_PLAY, SCORED, RESET, KICKOFF, OVERTIME, GAME_OVER}

var countries: Array[String] = ["FRANCE", "USA"]
var current_state: GameStateBase = null
var player_setup: Array[String] = ["FRANCE", ""]
var score: Array[int] = [0, 0]
var state_factory := GameStateFactory.new()
var time_since_paused := 0.0
var time_left: float


func _init() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS


func _ready() -> void:
	time_left = GAME_DURATION
	EventBus.game_state_transition_requested.connect(switch_state.bind())
	EventBus.impact_received.connect(_on_impact_received.bind())
	switch_state(State.RESET)


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


func increase_score(country_scored_for: String) -> void:
	var index_country_scoring := 1 if country_scored_for == countries[0] else 0
	score[index_country_scoring] += 1
	EventBus.score_changed.emit()


func is_coop() -> bool:
	return player_setup[0] == player_setup[1]


func is_single_player() -> bool:
	return player_setup[1].is_empty()


func is_game_tied() -> bool:
	return score[0] == score[1]


func is_time_up() -> bool:
	return time_left <= 0


func has_someone_scored() -> bool:
	return score[0] > 0 or score[1] > 0


func get_home_team() -> String:
	return countries[0]


func get_away_team() -> String:
	return countries[1]


func get_winner() -> String:
	assert(not is_game_tied())
	return countries[0] if score[0] > score[1] else countries[1]


func _on_impact_received(_impact_pos: Vector2, is_high_impact: bool) -> void:
	if is_high_impact:
		time_since_paused = Time.get_ticks_msec()
		get_tree().paused = true