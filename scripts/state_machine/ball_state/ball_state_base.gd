class_name BallStateBase
extends Node

signal state_transition_requested(new_state: Ball.State)

var animation_player: AnimationPlayer = null
var ball: Ball = null
var carrier: Player = null
var player_detection_area: Area2D = null


func setup(context_ball: Ball, context_carrier: Player, context_animation_player: AnimationPlayer, context_player_detection_area: Area2D) -> void:
	ball = context_ball
	carrier = context_carrier
	animation_player = context_animation_player
	player_detection_area = context_player_detection_area
