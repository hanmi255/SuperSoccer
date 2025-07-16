class_name BallChasingMovementStrategy
extends MovementStrategyBase


func get_steering_force() -> Vector2:
	return get_on_duty_steering_force() + get_density_around_ball_steering_force()


func should_apply_fallback() -> bool:
	return get_steering_force().length_squared() < 1


func get_on_duty_steering_force() -> Vector2:
	return player.weight_on_duty_steering * player.position.direction_to(ball.position)


func get_density_around_ball_steering_force() -> Vector2:
	var num_teammates_near_ball := ball.get_proximity_teammates_count(player.country)

	if num_teammates_near_ball == 0:
		return Vector2.ZERO

	var weight := 1 - 1.0 / num_teammates_near_ball
	var direction := ball.position.direction_to(player.position)
	return direction * weight


func get_fallback_steering_force() -> Vector2:
	var direction := player.position.direction_to(ball.position)
	var weight := ai_behavior.get_bicircular_weight(player.position, ball.position, 50, 1, 120, 0)
	return direction * weight
