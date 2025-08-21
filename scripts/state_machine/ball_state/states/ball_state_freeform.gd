class_name BallStateFreeform
extends BallStateBase

const MAX_CONTROL_HEIGHT := 25.0 # 最大控球高度

var time_since_freeform := 0.0


func _enter_tree() -> void:
	player_detection_area.body_entered.connect(_on_player_entered.bind())
	time_since_freeform = Time.get_ticks_msec()


func _process(delta: float) -> void:
	player_detection_area.monitoring = (Time.get_ticks_msec() - time_since_freeform) > state_data.lock_duration

	set_ball_animation_from_velocity()

	var friction := ball.friction_air if ball.height > 0 else ball.friction_ground

	ball.velocity = ball.velocity.move_toward(Vector2.ZERO, friction * delta)

	apply_gravity(delta, ball.BOUNCINESS)
	move_and_bounce(delta)


func _on_player_entered(body: Player) -> void:
	if body.can_carry_ball() and ball.height < MAX_CONTROL_HEIGHT:
		ball.carrier = body
		body.control_ball()
		transition_to_state(Ball.State.CARRIED)


func can_air_interact() -> bool:
	return ball.height > 0