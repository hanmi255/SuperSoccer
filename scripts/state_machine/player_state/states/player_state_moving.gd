class_name PlayerStateMoving
extends PlayerStateBase


func _process(_delta: float) -> void:
	if player.control_scheme == Player.ControlScheme.CPU:
		pass # TODO: 实现AI移动逻辑
	else:
		handle_player_movement()

	player.set_movement_animation()
	player.set_heading()


func handle_player_movement() -> void:
	var direction := KeyUtils.get_input_vector(player.control_scheme)
	player.velocity = direction * player.speed

	if player.is_carrying_ball() and KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
		transition_to_state(Player.State.PREPPING_SHOOT)

	# if player.velocity != Vector2.ZERO and KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
	# 	transition_to_state(Player.State.TACKLING)