class_name PlayerStateTackling
extends PlayerStateBase

const TACKLE_DURATION := 200

var time_start_tackle: int = 0


func _enter_tree() -> void:
	time_start_tackle = Time.get_ticks_msec()
	animation_player.play("tackle")


func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_start_tackle > TACKLE_DURATION:
		state_transition_requested.emit(Player.State.MOVING)