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
		func(p1: Player, p2: Player): return p1.position.distance_squared_to(player.position) < p2.position.distance_squared_to(player.position)
	)
	return teammates_in_view[0] if teammates_in_view.size() > 0 else null


func on_animation_finished() -> void:
	var pass_target := find_teammate_in_view()
	# 没有队友时，允许球向前移动一段距离
	if pass_target == null:
		ball.pass_to(ball.position + player.heading * player.speed)
	# 传给队友时，需要考虑队友的速度
	else:
		ball.pass_to(pass_target.position + pass_target.velocity)
	transition_to_state(Player.State.MOVING)