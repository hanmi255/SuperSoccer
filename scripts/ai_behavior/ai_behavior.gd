class_name AIBehavior
extends Node

const AI_TICK_FREQUENCY_DURATION := 200.0 # AI 处理间隔时间
const SPREAD_ASSIST_FACTOR := 0.8 # 助攻因子
const SHOOT_DISTANCE_THRESHOLD := 150.0 # 射门距离阈值
const SHOOT_PROBABILITY := 0.3 # 射门概率

var ball: Ball = null
var player: Player = null
var time_since_last_ai_tick := 0.0


func _ready() -> void:
	time_since_last_ai_tick = Time.get_ticks_msec() + randf_range(0, AI_TICK_FREQUENCY_DURATION)


func setup(context_player: Player, context_ball: Ball) -> void:
	player = context_player
	ball = context_ball


func process_ai() -> void:
	if Time.get_ticks_msec() - time_since_last_ai_tick > AI_TICK_FREQUENCY_DURATION:
		time_since_last_ai_tick = Time.get_ticks_msec()
		_perform_ai_movement()
		_perform_ai_decisions()


# 获取球员向球移动的转向力
func get_on_duty_steering_force() -> Vector2:
	return player.weight_on_duty_steering * player.position.direction_to(ball.position)


# 获取球员向目标球门移动的转向力
func get_carrier_steering_force() -> Vector2:
	var target := player.target_goal.get_center_target_position()
	var direction := player.position.direction_to(target)
	var weight := get_bicircular_weight(player.position, target, 100.0, 0, 150.0, 1)
	return direction * weight


# 获取球员向队友助攻的转向力
func get_assist_steering_force() -> Vector2:
	var spawn_difference := ball.carrier.spawn_position - player.spawn_position
	var assist_destination := ball.carrier.position - spawn_difference * SPREAD_ASSIST_FACTOR
	var direction := player.position.direction_to(assist_destination)
	var weight := get_bicircular_weight(player.position, assist_destination, 30, 0.2, 60, 1)
	return direction * weight


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


func _is_ball_carried_by_teammate() -> bool:
	return ball.carrier != null and ball.carrier != player and ball.carrier.country == player.country


# 调整球员朝向目标球门
func _face_towards_target_goal() -> void:
	if not player.is_facing_target_goal():
		player.heading = player.heading * -1


func _perform_ai_movement() -> void:
	var total_steering_force := Vector2.ZERO
	if player.is_carrying_ball():
		total_steering_force += get_carrier_steering_force()
	elif player.role != Player.Role.GOALIE:
		total_steering_force += get_on_duty_steering_force()
		if _is_ball_carried_by_teammate():
			total_steering_force += get_assist_steering_force()

	# 限制转向力的大小
	total_steering_force = total_steering_force.limit_length(1.0)
	player.velocity = total_steering_force * player.speed


func _perform_ai_decisions() -> void:
	if ball.carrier == player:
		var target := player.target_goal.get_center_target_position()
		if player.position.distance_to(target) < SHOOT_DISTANCE_THRESHOLD and randf() < SHOOT_PROBABILITY:
			_face_towards_target_goal()
			var shoot_direction := player.position.direction_to(player.target_goal.get_random_target_position())
			var _state_data = PlayerStateData.build().set_shoot_direction(shoot_direction).set_shoot_power(player.power)
			player.switch_state(Player.State.SHOOTING, _state_data)
