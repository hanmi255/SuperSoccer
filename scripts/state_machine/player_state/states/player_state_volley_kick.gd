class_name PlayerStateVolleyKick
extends PlayerStateBase

const BALL_HEIGHT_MIN := 1.0
const BALL_HEIGHT_MAX := 20.0
const BONUS_FACTOR := 1.5


func _enter_tree() -> void:
	animation_player.play("volley_kick")
	ball_detection_area.body_entered.connect(_on_ball_entered.bind())


func _on_ball_entered(contact_ball: Ball) -> void:
	if contact_ball.can_air_connect(BALL_HEIGHT_MIN, BALL_HEIGHT_MAX):
		var destination := target_goal.get_random_target_position()
		var direction := ball.position.direction_to(destination)
		contact_ball.shoot(direction * player.power * BONUS_FACTOR)


func on_animation_finished() -> void:
	transition_to_state(Player.State.RECOVERING)
