class_name AIBehaviorBase
extends Node

const AI_TICK_FREQUENCY_DURATION := 200.0 # AI 处理间隔时间

var ball: Ball = null
var opponent_detection_area: Area2D = null
var player: Player = null
var time_since_last_ai_tick := 0.0


func _ready() -> void:
	time_since_last_ai_tick = Time.get_ticks_msec() + randf_range(0, AI_TICK_FREQUENCY_DURATION)


func setup(context_player: Player, context_ball: Ball, context_opponent_detection_area: Area2D) -> void:
	player = context_player
	ball = context_ball
	opponent_detection_area = context_opponent_detection_area


func process_ai() -> void:
	if Time.get_ticks_msec() - time_since_last_ai_tick > AI_TICK_FREQUENCY_DURATION:
		time_since_last_ai_tick = Time.get_ticks_msec()
		_perform_ai_movement()
		_perform_ai_decisions()


func _perform_ai_movement() -> void:
	pass


func _perform_ai_decisions() -> void:
	pass


# 获取双圆环权重
func get_bicircular_weight(position: Vector2, center_target: Vector2, inner_radius: float, inner_weight: float, outer_radius: float, outer_weight: float) -> float:
	# 使用距离平方避免开平方运算
	var distance_squared := position.distance_squared_to(center_target)
	var inner_radius_squared := inner_radius * inner_radius
	var outer_radius_squared := outer_radius * outer_radius

	if distance_squared > outer_radius_squared:
		return outer_weight
	elif distance_squared < inner_radius_squared:
		return inner_weight
	else:
		# 计算线性插值系数
		var t := (sqrt(distance_squared) - inner_radius) / (outer_radius - inner_radius)
		return lerpf(inner_weight, outer_weight, t)


# 判断球是否被对手控制
func _is_ball_possessed_by_opponent() -> bool:
	return ball.carrier != null and ball.carrier.country != player.country


# 判断球是否被队友控制
func _is_ball_carried_by_teammate() -> bool:
	return ball.carrier != null and ball.carrier != player and ball.carrier.country == player.country


# 调整球员朝向目标球门
func _face_towards_target_goal() -> void:
	if not player.is_facing_target_goal():
		player.heading = player.heading * -1


# 判断是否有对手靠近
func _has_opponents_nearby() -> bool:
	var players := opponent_detection_area.get_overlapping_bodies()
	return players.find_custom(
		func(p: Player) -> bool:
			return p.country != player.country
	) != -1
