class_name PlayerStateHeader
extends PlayerStateBase

const BALL_HEIGHT_MIN := 10.0 # 头球最小高度
const BALL_HEIGHT_MAX := 30.0 # 头球最大高度
const BONUS_FACTOR := 1.3 # 头球加成因子
const HEIGHT_START := 0.1 # 头球开始球员高度
const V_VELOCITY_START := 1.5 # 头球开始垂直速度


func _enter_tree() -> void:
	animation_player.play("header")
	player.height = HEIGHT_START
	player.v_velocity = V_VELOCITY_START
	ball_detection_area.body_entered.connect(_on_ball_entered.bind())


func _process(_delta: float) -> void:
	if player.height <= 0:
		transition_to_state(Player.State.RECOVERING)


func _on_ball_entered(contact_ball: Ball) -> void:
	if contact_ball.can_air_connect(BALL_HEIGHT_MIN, BALL_HEIGHT_MAX):
		SoundPlayer.play(SoundPlayer.Sound.POWER_SHOOT)
		contact_ball.shoot(player.velocity.normalized() * player.power * BONUS_FACTOR)