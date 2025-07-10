class_name BallStateBase
extends Node

signal state_transition_requested(new_state: Ball.State)

var ball: Ball = null
var carrier: Player = null
var player_detection_area: Area2D = null


func setup(context_ball: Ball, context_carrier: Player, context_player_detection_area: Area2D) -> void:
	ball = context_ball
	carrier = context_carrier
	player_detection_area = context_player_detection_area
