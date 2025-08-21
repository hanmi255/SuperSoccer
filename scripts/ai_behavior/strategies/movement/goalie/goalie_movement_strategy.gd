class_name GoalieMovementStrategy
extends MovementStrategyBase

const PROXIMITY := 5.0 # 最大距离限制系数


func get_steering_force() -> Vector2:
	var top_position := player.own_goal.get_top_target_position()
	var center_position := player.spawn_position
	var bottom_position := player.own_goal.get_bottom_target_position()

	var target_y := clampf(ball.position.y, top_position.y, bottom_position.y)
	var destination := Vector2(center_position.x, target_y)
	var direction := player.position.direction_to(destination)
	var distance := player.position.distance_to(destination)
	var weight := clampf(distance / PROXIMITY, 0.0, 1.0)

	return direction * weight
