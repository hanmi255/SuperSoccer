class_name GameStateScored
extends GameStateBase

const CELEBRATION_DURATION := 3000

var time_since_celebration := 0.0


func _enter_tree() -> void:
	manager.increase_score(state_data.country_scored_on)
	time_since_celebration = Time.get_ticks_msec()


func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_since_celebration > CELEBRATION_DURATION:
		transition_state(GameManager.State.RESET, state_data)
