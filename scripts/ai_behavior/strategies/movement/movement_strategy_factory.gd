class_name MovementStrategyFactory
extends RefCounted

static func create_strategy(player: Player, ball: Ball, ai_behavior: AIBehaviorBase) -> MovementStrategyBase:
	if player.is_carrying_ball():
		return CarrierMovementStrategy.new(player, ball, ai_behavior)
	elif ai_behavior.is_ball_carried_by_teammate():
		return AssistMovementStrategy.new(player, ball, ai_behavior)
	elif ai_behavior.is_ball_possessed_by_opponent():
		return DefensiveMovementStrategy.new(player, ball, ai_behavior)
	elif ball.carrier == null:
		return BallChasingMovementStrategy.new(player, ball, ai_behavior)
	else:
		# 默认策略
		return BallChasingMovementStrategy.new(player, ball, ai_behavior)


static func create_goalie_strategy(player: Player, ball: Ball, ai_behavior: AIBehaviorBase) -> MovementStrategyBase:
	return GoalieMovementStrategy.new(player, ball, ai_behavior)
