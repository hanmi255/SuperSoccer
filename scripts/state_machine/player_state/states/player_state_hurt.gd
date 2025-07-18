class_name PlayerStateHurt
extends PlayerStateBase

const AIR_FRICTION := 35.0
const BALL_TUMBLE_SPEED := 100.0
const HURT_HEIGHT := 0.01
const HURT_DURATION := 1000
const HURT_V_VELOCITY := 2.0

var time_start_hurt := 0.0


func _enter_tree() -> void:
	animation_player.play("hurt")
	time_start_hurt = Time.get_ticks_msec()
	player.v_velocity = HURT_V_VELOCITY
	player.height = HURT_HEIGHT

	if ball.carrier == player:
		ball.tumble(state_data.hurt_direction * BALL_TUMBLE_SPEED)
		SoundPlayer.play(SoundPlayer.Sound.HURT)
		EventBus.impact_received.emit(player.position, false)


func _process(delta: float) -> void:
	if Time.get_ticks_msec() - time_start_hurt > HURT_DURATION:
		transition_to_state(Player.State.RECOVERING)

	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * AIR_FRICTION)
