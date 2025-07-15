class_name PlayerStateMoving
extends PlayerStateBase


func _process(_delta: float) -> void:
	if player.control_scheme == Player.ControlScheme.CPU:
		ai_behavior.process_ai()
	else:
		handle_player_movement()

	player.set_movement_animation()
	player.set_heading()


func handle_player_movement() -> void:
	# 1. 处理移动
	var direction := KeyUtils.get_input_vector(player.control_scheme)
	player.velocity = direction * player.speed
	
	# 2. 更新队友检测区域方向
	_update_teammate_detection_direction()
	
	# 3. 处理动作输入
	_handle_action_inputs()


func can_carry_ball() -> bool:
	return player.role != Player.Role.GOALIE


func can_teammate_pass_ball() -> bool:
	return ball.carrier != null and ball.carrier.country == player.country and ball.carrier.control_scheme == Player.ControlScheme.CPU


func can_pass() -> bool:
	return true


func _update_teammate_detection_direction() -> void:
	if player.velocity != Vector2.ZERO:
		teammate_detection_area.rotation = player.velocity.angle()


func _handle_action_inputs() -> void:
	var is_moving := player.velocity != Vector2.ZERO

	if player.is_carrying_ball():
		_handle_ball_carrier_actions()
	else:
		_handle_non_carrier_actions(is_moving)


func _handle_ball_carrier_actions() -> void:
	if KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.PASS):
		transition_to_state(Player.State.PASSING)
	elif KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
		transition_to_state(Player.State.PREPPING_SHOOT)


func _handle_non_carrier_actions(is_moving: bool) -> void:
	if KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SWAP_SOUL):
		EventBus.swap_soul_requested.emit(player)
		return

	if can_teammate_pass_ball() and KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.PASS):
		ball.carrier.get_pass_request(player)
		return

	if not KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
		return

	if ball.can_air_interact():
		_handle_air_interaction(is_moving)
	elif is_moving:
		transition_to_state(Player.State.TACKLING)


func _handle_air_interaction(is_moving: bool) -> void:
	if is_moving:
		transition_to_state(Player.State.HEADER)
	elif player.is_facing_target_goal():
		transition_to_state(Player.State.VOLLEY_KICK)
	else:
		transition_to_state(Player.State.BICYCLE_KICK)
