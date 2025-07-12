class_name PlayerStateBase
extends Node

signal state_transition_requested(new_state: Player.State, _state_data: PlayerStateData)

var animation_player: AnimationPlayer = null
var ball: Ball = null
var ball_detection_area: Area2D = null
var player: Player = null
var state_data := PlayerStateData.new()
var teammate_detection_area: Area2D = null


func setup(context_player: Player, context_ball: Ball, context_state_data: PlayerStateData, context_animation_player: AnimationPlayer, context_teammate_detection_area: Area2D, context_ball_detection_area: Area2D) -> void:
	player = context_player
	ball = context_ball
	state_data = context_state_data
	animation_player = context_animation_player
	teammate_detection_area = context_teammate_detection_area
	ball_detection_area = context_ball_detection_area


func transition_to_state(new_state: Player.State, _state_data: PlayerStateData = PlayerStateData.new()) -> void:
	state_transition_requested.emit(new_state, _state_data)


func on_animation_finished() -> void:
	pass
