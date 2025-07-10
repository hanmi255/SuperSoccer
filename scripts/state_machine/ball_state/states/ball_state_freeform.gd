class_name BallStateFreeform
extends BallStateBase

const BOUNCINESS := 0.8
const FRICTION_AIR := 35.0
const FRICTION_GROUND := 250.0


func _enter_tree() -> void:
	player_detection_area.body_entered.connect(_on_player_entered.bind())


func _process(delta: float) -> void:
	set_ball_animation_from_velocity()

	var friction := FRICTION_AIR if ball.height > 0 else FRICTION_GROUND

	ball.velocity = ball.velocity.move_toward(Vector2.ZERO, friction * delta)
	apply_gravity(delta, BOUNCINESS)
	ball.move_and_collide(ball.velocity * delta)


func _on_player_entered(body: Player) -> void:
	ball.carrier = body
	transition_to_state(Ball.State.CARRIED)