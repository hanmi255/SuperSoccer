class_name Camera
extends Camera2D

const CAMERA_OFFSET := 100.0 # 相机偏移量
const SMOOTHING_BALL_CARRIED := 2 # 球被携带时相机平滑速度
const SMOOTHING_BALL_DEFAULT := 8 # 球未被携带时相机平滑速度

@export var ball: Ball


func _process(_delta: float) -> void:
	if ball.carrier != null:
		position = ball.carrier.position + ball.carrier.heading * CAMERA_OFFSET
		position_smoothing_speed = SMOOTHING_BALL_CARRIED
	else:
		position = ball.position
		position_smoothing_speed = SMOOTHING_BALL_DEFAULT
