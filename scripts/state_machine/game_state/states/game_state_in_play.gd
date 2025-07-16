class_name GameStateInPlay
extends GameStateBase


func _enter_tree() -> void:
	EventBus.team_scored.connect(_on_team_scored.bind())


func _process(delta: float) -> void:
	if manager.time_left <= 0:
		return

	manager.time_left -= delta

	if manager.time_left <= 0:
		manager.time_left = 0

		if manager.score[0] == manager.score[1]:
			transition_state(GameManager.State.OVERTIME)
		else:
			transition_state(GameManager.State.GAME_OVER)


func _on_team_scored(country_scored_for: String) -> void:
	transition_state(GameManager.State.SCORED,GameStateData.build().set_country_scored_for(country_scored_for))