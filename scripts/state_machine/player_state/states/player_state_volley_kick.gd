class_name PlayerStateVolleyKick
extends PlayerStateBase

const BALL_HEIGHT_MIN := 1.0 # 凌空射门最小高度
const BALL_HEIGHT_MAX := 20.0 # 凌空射门最大高度
const BONUS_FACTOR := 1.5 # 凌空射门加成因子


func _enter_tree() -> void:
	animation_player.play("volley_kick")
	ball_detection_area.body_entered.connect(_on_ball_entered.bind())


func _on_ball_entered(contact_ball: Ball) -> void:
	if contact_ball.can_air_connect(BALL_HEIGHT_MIN, BALL_HEIGHT_MAX):
		var destination := target_goal.get_random_target_position()
		var direction := ball.position.direction_to(destination)
		SoundPlayer.play(SoundPlayer.Sound.POWER_SHOOT)
		contact_ball.shoot(direction * player.power * BONUS_FACTOR)


func on_animation_finished() -> void:
	transition_to_state(Player.State.RECOVERING)
