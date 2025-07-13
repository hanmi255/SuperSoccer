class_name PlayerStateRecovering
extends PlayerStateBase

const RECOVERY_DURATION := 500 # 恢复持续时间

var _time_start_recovery: int = 0


func _enter_tree() -> void:
	_time_start_recovery = Time.get_ticks_msec()
	player.velocity = Vector2.ZERO
	animation_player.play("recover")


func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - _time_start_recovery > RECOVERY_DURATION:
		player.switch_state(Player.State.MOVING)
