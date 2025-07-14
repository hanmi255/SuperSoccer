class_name AIBehaviorField
extends AIBehaviorBase


func _perform_ai_movement() -> void:
	var movement_strategy = MovementStrategyFactory.create_strategy(player, ball, self)
	var total_steering_force = movement_strategy.get_steering_force()

	# 应用回退策略（如果需要）
	if movement_strategy.should_apply_fallback():
		total_steering_force += movement_strategy.get_fallback_steering_force()

	# 限制操控力的大小
	total_steering_force = total_steering_force.limit_length(1.0)
	player.velocity = total_steering_force * player.speed


func _perform_ai_decisions() -> void:
	var decision_strategy = DecisionStrategyFactory.create_strategy_from_ai_behavior(self)
	decision_strategy.make_decisions()
