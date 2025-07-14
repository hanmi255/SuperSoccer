class_name GoalieDecisionStrategy
extends DecisionStrategyBase

func make_decisions() -> void:
	_handle_ball_threat()


func _handle_ball_threat() -> void:
	if ball.is_headed_for_scoring_area(player.own_goal.get_scoring_area()):
		player.switch_state(Player.State.DIVING)
