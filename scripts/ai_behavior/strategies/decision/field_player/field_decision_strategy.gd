class_name FieldDecisionStrategy
extends DecisionStrategyBase

const PASS_PROBABILITY := 0.1 # 传球概率
const SHOOT_DISTANCE_THRESHOLD := 150.0 # 射门距离阈值
const SHOOT_PROBABILITY := 0.3 # 射门概率
const TACKLE_DISTANCE_THRESHOLD := 15.0 # 铲球距离阈值
const TACKLE_PROBABILITY := 0.15 # 铲球概率


func make_decisions() -> void:
	_handle_opponent_possession()
	_handle_player_possession()


func _handle_opponent_possession() -> void:
	if not ai_behavior.is_ball_possessed_by_opponent():
		return

	var distance_to_ball = player.position.distance_to(ball.position)
	if distance_to_ball < TACKLE_DISTANCE_THRESHOLD and randf() < TACKLE_PROBABILITY:
		player.switch_state(Player.State.TACKLING)


func _handle_player_possession() -> void:
	if ball.carrier != player:
		return

	var target := player.target_goal.get_center_target_position()
	var distance_to_goal = player.position.distance_to(target)

	# 优先考虑射门
	if distance_to_goal < SHOOT_DISTANCE_THRESHOLD and randf() < SHOOT_PROBABILITY:
		_execute_shoot()
	# 其次考虑传球
	elif randf() < PASS_PROBABILITY and ai_behavior.has_opponents_nearby() and _has_teammate_in_view():
		_execute_pass()


func _execute_shoot() -> void:
	ai_behavior.face_towards_target_goal()
	var shoot_direction := player.position.direction_to(player.target_goal.get_random_target_position())
	var state_data = PlayerStateData.build().set_shoot_direction(shoot_direction).set_shoot_power(player.power)
	player.switch_state(Player.State.SHOOTING, state_data)


func _execute_pass() -> void:
	player.switch_state(Player.State.PASSING)


func _has_teammate_in_view() -> bool:
	var players_in_view := ai_behavior.teammate_detection_area.get_overlapping_bodies()
	var teammates_in_view := players_in_view.filter(
		func(p: Player): return p != player and p.country == player.country
	)
	return teammates_in_view.size() > 0
