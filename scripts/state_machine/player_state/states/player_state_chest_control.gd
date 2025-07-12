class_name PlayerStateChestControl
extends PlayerStateBase

const CONTROL_DURATION: float = 500.0

var _time_since_control: float = 0.0


func _enter_tree():
	animation_player.play("chest_control")
	player.velocity = Vector2.ZERO
	_time_since_control = Time.get_ticks_msec()


func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - _time_since_control > CONTROL_DURATION:
		transition_to_state(Player.State.MOVING)
