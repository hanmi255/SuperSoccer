class_name PlayerStatePreppingShoot
extends PlayerStateBase

const DURATION_MAX_BONUS := 1000.0
const EASE_REWARD_FACTOR := 2.0

var shoot_direction := Vector2.ZERO
var time_start_shoot := 0.0

func _enter_tree() -> void:
	animation_player.play("prep_kick")
	player.velocity = Vector2.ZERO
	time_start_shoot = Time.get_ticks_msec()


func _process(delta: float) -> void:
	shoot_direction += KeyUtils.get_input_vector(player.control_scheme) * delta

	if KeyUtils.is_action_just_released(player.control_scheme, KeyUtils.Action.SHOOT):
		var duration_press := clampf(Time.get_ticks_msec() - time_start_shoot, 0.0, DURATION_MAX_BONUS)
		var ease_time := duration_press / DURATION_MAX_BONUS
		var bonus := ease(ease_time, EASE_REWARD_FACTOR)
		var shoot_power := player.power * (1 + bonus)
		shoot_direction = shoot_direction.normalized()

		var _state_data = PlayerStateData.build().set_shoot_direction(shoot_direction).set_shoot_power(shoot_power)
		transition_to_state(Player.State.SHOOTING, _state_data)