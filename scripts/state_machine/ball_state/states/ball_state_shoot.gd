class_name BallStateShoot
extends BallStateBase

const SHOOT_DURATION := 1000
const SHOOT_HEIGHT := 10.0
const SHOOT_SPRITE_SCALE := 0.8

var time_finish_shoot: int = 0


func _enter_tree() -> void:
	set_ball_animation_from_velocity()

	ball_sprite.scale.y = SHOOT_SPRITE_SCALE
	ball.height = SHOOT_HEIGHT
	time_finish_shoot = Time.get_ticks_msec() + SHOOT_DURATION


func _process(delta: float) -> void:
	if Time.get_ticks_msec() > time_finish_shoot:
		transition_to_state(Ball.State.FREEFORM)
	else:
		move_and_bounce(delta)


func _exit_tree() -> void:
	ball_sprite.scale.y = 1.0