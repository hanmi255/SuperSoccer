class_name Camera
extends Camera2D

const CAMERA_OFFSET := 100.0 # 相机偏移量
const SHAKE_INTENSITY := 5 # 抖动强度
const SHAKE_DURATION := 120 # 抖动持续时间
const SMOOTHING_BALL_CARRIED := 2 # 球被携带时相机平滑速度
const SMOOTHING_BALL_DEFAULT := 8 # 球未被携带时相机平滑速度

@export var ball: Ball

var is_shaking := false
var time_start_shake := 0.0

func _init() -> void:
	EventBus.impact_received.connect(_on_impact_received.bind())


func _process(_delta: float) -> void:
	if ball.carrier != null:
		position = ball.carrier.position + ball.carrier.heading * CAMERA_OFFSET
		position_smoothing_speed = SMOOTHING_BALL_CARRIED
	else:
		position = ball.position
		position_smoothing_speed = SMOOTHING_BALL_DEFAULT

	if is_shaking and Time.get_ticks_msec() - time_start_shake < SHAKE_DURATION:
		offset = Vector2(randf_range(-SHAKE_INTENSITY, SHAKE_INTENSITY), randf_range(-SHAKE_INTENSITY, SHAKE_INTENSITY))
	else:
		is_shaking = false
		offset = Vector2.ZERO


func _on_impact_received(_impact_pos: Vector2, is_high_impact: bool) -> void:
	if is_high_impact:
		is_shaking = true
		time_start_shake = Time.get_ticks_msec()