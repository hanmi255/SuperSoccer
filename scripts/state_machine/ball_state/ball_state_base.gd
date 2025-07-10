class_name BallStateBase
extends Node

signal state_transition_requested(new_state: Ball.State, _state_data: BallStateData)

var animation_player: AnimationPlayer = null
var ball: Ball = null
var ball_sprite: Sprite2D = null
var carrier: Player = null
var player_detection_area: Area2D = null
var state_data := BallStateData.new()


func setup(context_ball: Ball, context_ball_sprite: Sprite2D, context_carrier: Player, context_state_data: BallStateData, context_animation_player: AnimationPlayer, context_player_detection_area: Area2D) -> void:
	ball = context_ball
	ball_sprite = context_ball_sprite
	carrier = context_carrier
	state_data = context_state_data
	animation_player = context_animation_player
	player_detection_area = context_player_detection_area


func transition_to_state(new_state: Ball.State, _state_data: BallStateData = BallStateData.new()) -> void:
	state_transition_requested.emit(new_state, _state_data)
