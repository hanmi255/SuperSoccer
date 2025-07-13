class_name AIBehavior
extends Node

const AI_TICK_FREQUENCY_DURATION := 200.0 # AI 处理间隔时间

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


func _perform_ai_movement() -> void:
	var total_steering_force := Vector2.ZERO
	total_steering_force += get_on_duty_steering_force()

	# 限制转向力的大小
	total_steering_force = total_steering_force.limit_length(1.0)
	player.velocity = total_steering_force * player.speed


func _perform_ai_decisions() -> void:
	pass


# 获取球员在场上位置的权重，用于计算球员的转向力
func get_on_duty_steering_force() -> Vector2:
	return player.weight_on_duty_steering * player.position.direction_to(ball.position)
