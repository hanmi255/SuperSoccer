class_name PlayerStateBase
extends Node


var ai_behavior: AIBehaviorBase = null
var animation_player: AnimationPlayer = null
var ball: Ball = null
var ball_detection_area: Area2D = null
var player: Player = null
var state_data := PlayerStateData.new()
var teammate_detection_area: Area2D = null
var opponent_detection_area: Area2D = null
var own_goal: Goal = null
var target_goal: Goal = null
var tackle_damage_emitter_area: Area2D = null


func setup(context_player: Player, context_ball: Ball, context_state_data: PlayerStateData, context_animation_player: AnimationPlayer, context_teammate_detection_area: Area2D, context_opponent_detection_area: Area2D, context_ball_detection_area: Area2D, context_own_goal: Goal, context_target_goal: Goal, context_tackle_damage_emitter_area: Area2D, context_ai_behavior: AIBehaviorBase) -> void:
	player = context_player
	ball = context_ball
	state_data = context_state_data
	animation_player = context_animation_player
	teammate_detection_area = context_teammate_detection_area
	opponent_detection_area = context_opponent_detection_area
	ball_detection_area = context_ball_detection_area
	own_goal = context_own_goal
	target_goal = context_target_goal
	tackle_damage_emitter_area = context_tackle_damage_emitter_area
	ai_behavior = context_ai_behavior


func transition_to_state(new_state: Player.State, data: PlayerStateData = PlayerStateData.new()) -> void:
	EventBus.player_state_transition_requested.emit(player, new_state, data)


func can_carry_ball() -> bool:
	return false


func can_pass() -> bool:
	return false


func on_animation_finished() -> void:
	pass
