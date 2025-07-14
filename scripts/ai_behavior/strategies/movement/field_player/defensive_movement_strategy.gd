class_name DefensiveMovementStrategy
extends MovementStrategyBase


func get_steering_force() -> Vector2:
	return player.weight_on_duty_steering * player.position.direction_to(ball.position)


func should_apply_fallback() -> bool:
	return get_steering_force().length_squared() < 1


func get_fallback_steering_force() -> Vector2:
	var direction := player.position.direction_to(player.spawn_position)
	var weight := ai_behavior.get_bicircular_weight(player.position, player.spawn_position, 30, 0, 100, 1)
	return direction * weight
