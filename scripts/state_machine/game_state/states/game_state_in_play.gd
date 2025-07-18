class_name GameStateInPlay
extends GameStateBase


func _enter_tree() -> void:
	EventBus.team_scored.connect(_on_team_scored.bind())


func _process(delta: float) -> void:
	if manager.is_time_up():
		return

	manager.time_left -= delta

	if manager.is_time_up():
		manager.time_left = 0

		if manager.current_match.is_tied():
			transition_state(GameManager.State.OVERTIME)
		else:
			transition_state(GameManager.State.GAME_OVER)


func _on_team_scored(country_scored_on: String) -> void:
	transition_state(GameManager.State.SCORED, GameStateData.build().set_country_scored_on(country_scored_on))