class_name MovementStrategyBase
extends RefCounted

var player: Player
var ball: Ball
var ai_behavior: AIBehaviorBase


func _init(context_player: Player, context_ball: Ball, context_ai_behavior: AIBehaviorBase):
	player = context_player
	ball = context_ball
	ai_behavior = context_ai_behavior


func get_steering_force() -> Vector2:
	return Vector2.ZERO


func should_apply_fallback() -> bool:
	return false


func get_fallback_steering_force() -> Vector2:
	return Vector2.ZERO
