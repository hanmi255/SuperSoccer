class_name GameStateReset
extends GameStateBase


func _enter_tree() -> void:
	EventBus.team_reset.emit()
	EventBus.kickoff_ready.connect(_on_kickoff_ready.bind())


func _on_kickoff_ready() -> void:
	transition_state(GameManager.State.KICKOFF)