class_name PlayerStateHeader
extends PlayerStateBase

const BALL_HEIGHT_MIN := 10.0
const BALL_HEIGHT_MAX := 30.0
const BONUS_FACTOR := 1.3
const HEIGHT_START := 0.1
const V_VELOCITY_START := 1.5


func _enter_tree() -> void:
	animation_player.play("header")
	player.height = HEIGHT_START
	player.v_velocity = V_VELOCITY_START
	ball_detection_area.body_entered.connect(_on_ball_entered.bind())


func _process(_delta: float) -> void:
	if player.height <= 0:
		transition_to_state(Player.State.RECOVERING)


func _on_ball_entered(contact_ball: Ball) -> void:
	if contact_ball.can_header_connect():
		contact_ball.shoot(player.velocity.normalized() * player.power * BONUS_FACTOR)