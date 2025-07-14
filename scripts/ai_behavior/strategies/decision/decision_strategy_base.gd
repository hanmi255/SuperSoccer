class_name DecisionStrategyBase
extends RefCounted

var player: Player
var ball: Ball
var ai_behavior: AIBehaviorBase


func _init(context_player: Player, context_ball: Ball, context_ai_behavior: AIBehaviorBase):
	player = context_player
	ball = context_ball
	ai_behavior = context_ai_behavior


func make_decisions() -> void:
	pass
