class_name BallStateCarried
extends BallStateBase

const DRIBBLE_FREQUENCY := 10.0 # 震荡频率
const DRIBBLE_INTENSITY := 3.0 # 震荡强度
const OFFSET_FROM_CARRIER := Vector2(10, 3) # 球与球员的偏移量
const RANDOM_FACTOR := 0.4 # 随机因子

var dribble_time := 0.0

func _enter_tree() -> void:
	assert(carrier != null)
	EventBus.ball_possessed.emit(carrier.full_name)


func _process(delta: float) -> void:
	var offset := Vector2.ZERO
	dribble_time += delta
	
	if carrier.velocity != Vector2.ZERO:
		# 仅在横向移动时，才进行震荡
		if carrier.velocity.x != 0:
			# 基础震荡
			offset.x = cos(dribble_time * DRIBBLE_FREQUENCY) * DRIBBLE_INTENSITY
			offset.y = sin(dribble_time * DRIBBLE_FREQUENCY * 1.5) * (DRIBBLE_INTENSITY * 0.7)
			
			# 添加随机变化
			offset.x += (randf() * 2.0 - 1.0) * RANDOM_FACTOR
			offset.y += (randf() * 2.0 - 1.0) * RANDOM_FACTOR
		
		if carrier.heading.x >= 0:
			animation_player.play("roll")
			animation_player.advance(0)
		else:
			animation_player.play_backwards("roll")
			animation_player.advance(0)
	else:
		animation_player.play("idle")

	apply_gravity(delta)

	ball.position = carrier.position + Vector2(
		carrier.heading.x * OFFSET_FROM_CARRIER.x + offset.x,
		OFFSET_FROM_CARRIER.y + offset.y
	)


func _exit_tree() -> void:
	EventBus.ball_released.emit()