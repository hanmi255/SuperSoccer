class_name PlayerStatePreppingShoot
extends PlayerStateBase

const MAX_BONUS_DURATION := 1000.0 # 准备射门持续时间最大奖励
const EASE_REWARD_FACTOR := 2.0 # 准备射门持续时间奖励衰减因子

var _shoot_direction := Vector2.ZERO
var _time_start_shoot := 0.0

func _enter_tree() -> void:
	animation_player.play("prep_kick")
	player.velocity = Vector2.ZERO
	_time_start_shoot = Time.get_ticks_msec()
	_shoot_direction = player.heading


func _process(delta: float) -> void:
	_shoot_direction += KeyUtils.get_input_vector(player.control_scheme) * delta

	if KeyUtils.is_action_just_released(player.control_scheme, KeyUtils.Action.SHOOT):
		var duration_press := clampf(Time.get_ticks_msec() - _time_start_shoot, 0.0, MAX_BONUS_DURATION)
		var ease_time := duration_press / MAX_BONUS_DURATION
		var bonus := ease(ease_time, EASE_REWARD_FACTOR)
		var shoot_power := player.power * (1 + bonus)
		_shoot_direction = _shoot_direction.normalized()

		var _state_data = PlayerStateData.build().set_shoot_direction(_shoot_direction).set_shoot_power(shoot_power)
		transition_to_state(Player.State.SHOOTING, _state_data)