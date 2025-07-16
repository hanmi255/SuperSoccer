class_name BallStateBase
extends Node


const GRAVITY := 10.0 # 重力加速度

var animation_player: AnimationPlayer = null
var ball: Ball = null
var ball_sprite: Sprite2D = null
var carrier: Player = null
var player_detection_area: Area2D = null
var shoot_particles: GPUParticles2D = null
var state_data := BallStateData.new()


func setup(context_ball: Ball, context_ball_sprite: Sprite2D, context_carrier: Player, context_state_data: BallStateData, context_animation_player: AnimationPlayer, context_player_detection_area: Area2D, context_shoot_particles: GPUParticles2D) -> void:
	ball = context_ball
	ball_sprite = context_ball_sprite
	carrier = context_carrier
	state_data = context_state_data
	animation_player = context_animation_player
	player_detection_area = context_player_detection_area
	shoot_particles = context_shoot_particles


func transition_to_state(new_state: Ball.State, data: BallStateData = BallStateData.new()) -> void:
	EventBus.ball_state_transition_requested.emit(new_state, data)


func set_ball_animation_from_velocity() -> void:
	if ball.velocity.x > 0:
		animation_player.play("roll")
		animation_player.advance(0)
	elif ball.velocity.x < 0:
		animation_player.play_backwards("roll")
		animation_player.advance(0)
	else:
		animation_player.play("idle")


func apply_gravity(delta: float, bounciness: float = 0.0) -> void:
	# 球在空中或有向上的速度时才应用重力
	if ball.height <= 0 and ball.v_velocity <= 0:
		return

	# 应用重力
	ball.v_velocity -= GRAVITY * delta
	ball.height += ball.v_velocity

	# 处理落地反弹
	if ball.height < 0:
		ball.height = 0
		if bounciness > 0 and ball.v_velocity < 0:
			ball.v_velocity = - ball.v_velocity * bounciness
			ball.velocity *= bounciness


func move_and_bounce(delta: float) -> void:
	var collision := ball.move_and_collide(ball.velocity * delta)
	if collision != null:
		ball.velocity = ball.velocity.bounce(collision.get_normal()) * ball.BOUNCINESS
		ball.switch_state(Ball.State.FREEFORM)


func can_air_interact() -> bool:
	return false
