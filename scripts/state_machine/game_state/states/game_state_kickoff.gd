class_name GameStateKickoff
extends GameStateBase

var valid_control_schemes := []


func _enter_tree() -> void:
	var country_starting := state_data.country_scored_on
	# 如果country_starting为空，则默认为第一个国家
	if country_starting.is_empty():
		country_starting = manager.get_home_team()
	# 添加country_starting对应的控制模式
	if country_starting == manager.player_setup[0]:
		valid_control_schemes.append(Player.ControlScheme.P1)
	if country_starting == manager.player_setup[1]:
		valid_control_schemes.append(Player.ControlScheme.P2)
	if valid_control_schemes.size() == 0:
		valid_control_schemes.append(Player.ControlScheme.P1)
		valid_control_schemes.append(Player.ControlScheme.P2)


func _process(_delta: float) -> void:
	for control_scheme: Player.ControlScheme in valid_control_schemes:
		if KeyUtils.is_action_just_pressed(control_scheme, KeyUtils.Action.PASS):
			EventBus.kickoff_started.emit()
			AudioPlayer.play(AudioPlayer.Sound.WHISTLE)
			transition_state(GameManager.State.IN_PLAY)
