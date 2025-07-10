class_name PlayerStateShooting
extends PlayerStateBase


func _enter_tree() -> void:
	animation_player.play("kick")


func on_animation_finished() -> void:
	if player.control_scheme == Player.ControlScheme.CPU:
		transition_to_state(Player.State.RECOVERING)
	else:
		transition_to_state(Player.State.MOVING)

	shoot_ball()


func shoot_ball() -> void:
	ball.shoot(state_data.shoot_direction * state_data.shoot_power)