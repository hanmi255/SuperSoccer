class_name Ball
extends AnimatableBody2D

enum State {CARRIED, FREEFORM, SHOOT}

const BOUNCINESS := 0.8
const HIGH_PASS_DISTANCE_THRESHOLD := 130.0

@export var header_connect_min_height: float = 20.0
@export var header_connect_max_height: float = 40.0
@export var friction_air: float
@export var friction_ground: float

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ball_sprite: Sprite2D = $BallSprite
@onready var player_detection_area: Area2D = $PlayerDetectionArea

var carrier: Player = null
var current_state: BallStateBase = null
var height := 0.0
var state_factory := BallStateFactory.new()
var velocity := Vector2.ZERO
var v_velocity := 0.0

func _ready() -> void:
	switch_state(Ball.State.FREEFORM)


func _process(_delta: float) -> void:
	ball_sprite.position = Vector2.UP * height


func switch_state(state: Ball.State, state_data: BallStateData = BallStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()

	current_state = state_factory.get_fresh_state(state)

	current_state.setup(self, ball_sprite, carrier, state_data, animation_player, player_detection_area)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "BallStateMachine: " + str(state)

	call_deferred("add_child", current_state)


func shoot(shoot_velocity: Vector2) -> void:
	velocity = shoot_velocity
	carrier = null
	switch_state(Ball.State.SHOOT)


func pass_to(destination: Vector2) -> void:
	var direction := position.direction_to(destination)
	var distance := position.distance_to(destination)
	var h_velocity := sqrt(2 * distance * friction_ground)
	velocity = direction * h_velocity

	# 高抛球不使用 '2' 作为抛物线公式，而是使用 '1.8' 作为抛物线公式
	# 因为需要球在空中飞行的时间更长，落在球员头顶的位置施展 '倒挂金钩' 而非脚下，所以需要更小的抛物线公式
	# '1.8' 是根据实际测试得出的一个经验值，可以调整以适应不同的游戏需求，
	# 如果需要球在空中飞行的时间更短，可以调整这个值为 '2' 或更大
	if distance > HIGH_PASS_DISTANCE_THRESHOLD:
		v_velocity = BallStateBase.GRAVITY * distance / (1.8 * h_velocity)

	carrier = null
	switch_state(Ball.State.FREEFORM)


func stop() -> void:
	velocity = Vector2.ZERO


func can_air_interact() -> bool:
	return current_state != null and current_state.can_air_interact()


func can_header_connect() -> bool:
	return height >= header_connect_min_height and height <= header_connect_max_height