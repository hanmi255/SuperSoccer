class_name DecisionStrategyFactory
extends RefCounted

enum PlayerRole {
	FIELD_PLAYER,
	GOALKEEPER
}


static func create_strategy(player_role: PlayerRole, player: Player, ball: Ball, ai_behavior: AIBehaviorBase) -> DecisionStrategyBase:
	match player_role:
		PlayerRole.FIELD_PLAYER:
			return FieldDecisionStrategy.new(player, ball, ai_behavior)
		PlayerRole.GOALKEEPER:
			return GoalieDecisionStrategy.new(player, ball, ai_behavior)
		_:
			push_error("Unknown player role: " + str(player_role))
			return FieldDecisionStrategy.new(player, ball, ai_behavior)


# 辅助方法，根据AI行为类型自动判断角色
static func create_strategy_from_ai_behavior(ai_behavior: AIBehaviorBase) -> DecisionStrategyBase:
	var player_role: PlayerRole

	if ai_behavior is AIBehaviorGoalie:
		player_role = PlayerRole.GOALKEEPER
	else:
		player_role = PlayerRole.FIELD_PLAYER

	return create_strategy(player_role, ai_behavior.player, ai_behavior.ball, ai_behavior)
