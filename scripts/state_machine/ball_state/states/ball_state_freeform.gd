class_name BallStateFreeform
extends BallStateBase


func _enter_tree() -> void:
	player_detection_area.body_entered.connect(_on_player_entered.bind())


func _process(delta: float) -> void:
	set_ball_animation_from_velocity()

	var friction := ball.friction_air if ball.height > 0 else ball.friction_ground

	ball.velocity = ball.velocity.move_toward(Vector2.ZERO, friction * delta)

	apply_gravity(delta, ball.BOUNCINESS)
	move_and_bounce(delta)


func _on_player_entered(body: Player) -> void:
	ball.carrier = body
	transition_to_state(Ball.State.CARRIED)


func can_air_interact() -> bool:
	return true