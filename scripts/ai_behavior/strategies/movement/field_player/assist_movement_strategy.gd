class_name AssistMovementStrategy
extends MovementStrategyBase

const SPREAD_ASSIST_FACTOR := 0.8 # 传球助攻因子


func get_steering_force() -> Vector2:
	var spawn_difference := ball.carrier.spawn_position - player.spawn_position
	var assist_destination := ball.carrier.position - spawn_difference * SPREAD_ASSIST_FACTOR
	var direction := player.position.direction_to(assist_destination)
	var weight := ai_behavior.get_bicircular_weight(player.position, assist_destination, 30, 0.2, 60, 1)
	return direction * weight
