class_name PlayerStateTackling
extends PlayerStateBase

const PRIOR_RECOVERY_DURATION := 200
const GROUND_FRICTION := 250.0

var is_tackle_completed: bool = false
var time_finish_tackle: int = 0


func _enter_tree() -> void:
	animation_player.play("tackle")


func _physics_process(delta: float) -> void:
	if not is_tackle_completed:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, GROUND_FRICTION * delta)
		if player.velocity == Vector2.ZERO:
			is_tackle_completed = true
			time_finish_tackle = Time.get_ticks_msec()
	
	elif Time.get_ticks_msec() - time_finish_tackle > PRIOR_RECOVERY_DURATION:
		state_transition_requested.emit(Player.State.RECOVERING)