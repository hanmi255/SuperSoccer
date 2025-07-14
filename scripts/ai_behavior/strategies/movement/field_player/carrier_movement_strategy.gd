class_name CarrierMovementStrategy
extends MovementStrategyBase


func get_steering_force() -> Vector2:
	var target := player.target_goal.get_center_target_position()
	var direction := player.position.direction_to(target)
	var weight := ai_behavior.get_bicircular_weight(player.position, target, 100.0, 0, 150.0, 1)
	return direction * weight
