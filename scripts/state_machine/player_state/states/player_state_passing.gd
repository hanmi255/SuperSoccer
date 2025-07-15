class_name PlayerStatePassing
extends PlayerStateBase


func _enter_tree() -> void:
	animation_player.play("kick")
	player.velocity = Vector2.ZERO


func find_teammate_in_view() -> Player:
	var players_in_view := teammate_detection_area.get_overlapping_bodies()
	var teammates_in_view := players_in_view.filter(
		func(p: Player): return p != player
	)
	teammates_in_view.sort_custom(
		func(a: Player, b: Player): return a.position.distance_squared_to(player.position) < b.position.distance_squared_to(player.position)
	)
	return teammates_in_view[0] if teammates_in_view.size() > 0 else null


func on_animation_finished() -> void:
	var pass_target := state_data.pass_target

	# 如果没有预设目标，查找视野内最近的队友
	if pass_target == null:
		pass_target = find_teammate_in_view()

	# 确定传球目标位置
	var target_position: Vector2
	if pass_target:
		# 传给队友时，预测队友移动位置
		target_position = pass_target.position + pass_target.velocity
	else:
		# 无目标时，向前传球一段距离
		target_position = ball.position + player.heading * player.speed * 1.5

	# 执行传球
	ball.pass_to(target_position)
	transition_to_state(Player.State.MOVING)