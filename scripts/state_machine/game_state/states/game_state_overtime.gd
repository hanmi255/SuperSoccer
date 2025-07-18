class_name GameStateOvertime
extends GameStateBase


func _enter_tree() -> void:
	EventBus.team_scored.connect(_on_team_scored.bind())


func _on_team_scored(country_scored_on: String) -> void:
	manager.increase_score(country_scored_on)
	transition_state(GameManager.State.GAME_OVER)