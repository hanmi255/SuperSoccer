class_name PlayerStateBase
extends Node

signal state_transition_requested(new_state: Player.State)

var player: Player = null
var animation_player: AnimationPlayer = null


func setup(context_player: Player, context_animation_player: AnimationPlayer) -> void:
	player = context_player
	animation_player = context_animation_player
