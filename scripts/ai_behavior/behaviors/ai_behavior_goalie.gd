class_name AIBehaviorGoalie
extends AIBehaviorBase

const PROXIMITY := 5.0 # 守门员靠近球门时的距离阈值


func _perform_ai_movement() -> void:
	var total_steering_force := Vector2.ZERO
	total_steering_force += _get_goalie_steering_force()

	# 限制转向力的大小
	total_steering_force = total_steering_force.limit_length(1.0)
	player.velocity = total_steering_force * player.speed


func _perform_ai_decisions() -> void:
	if ball.is_headed_for_scoring_area(player.own_goal.get_scoring_area()):
		player.switch_state(Player.State.DIVING)


# 获取守门员向球门移动的转向力
func _get_goalie_steering_force() -> Vector2:
	var top_position := player.own_goal.get_top_target_position()
	var center_position := player.spawn_position
	var bottom_position := player.own_goal.get_bottom_target_position()

	var target_y := clampf(ball.position.y, top_position.y, bottom_position.y)
	var destination := Vector2(center_position.x, target_y)
	var direction := player.position.direction_to(destination)
	var distance := player.position.distance_to(destination)
	var weight := clampf(distance / PROXIMITY, 0.0, 1.0)

	return direction * weight