class_name BallChasingMovementStrategy
extends MovementStrategyBase


func get_steering_force() -> Vector2:
	return player.weight_on_duty_steering * player.position.direction_to(ball.position)


func should_apply_fallback() -> bool:
	return get_steering_force().length_squared() < 1


func get_fallback_steering_force() -> Vector2:
	var direction := player.position.direction_to(ball.position)
	var weight := ai_behavior.get_bicircular_weight(player.position, ball.position, 50, 1, 120, 0)
	return direction * weight
