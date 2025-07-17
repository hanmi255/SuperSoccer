class_name PlayerStateTackling
extends PlayerStateBase

const PRIOR_RECOVERY_DURATION := 200 # 铲球后恢复持续时间
const GROUND_FRICTION := 250.0 # 地面摩擦力

var _is_tackle_completed: bool = false
var _time_finish_tackle: int = 0


func _enter_tree() -> void:
	animation_player.play("tackle")
	AudioPlayer.play(AudioPlayer.Sound.TACKLING)
	tackle_damage_emitter_area.set_deferred("monitoring", true)


func _physics_process(delta: float) -> void:
	if not _is_tackle_completed:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, GROUND_FRICTION * delta)

		if player.velocity == Vector2.ZERO:
			_is_tackle_completed = true
			_time_finish_tackle = Time.get_ticks_msec()

	elif Time.get_ticks_msec() - _time_finish_tackle > PRIOR_RECOVERY_DURATION:
		transition_to_state(Player.State.RECOVERING)


func _exit_tree() -> void:
	tackle_damage_emitter_area.set_deferred("monitoring", false)