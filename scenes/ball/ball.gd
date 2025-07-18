class_name Ball
extends AnimatableBody2D

enum State {CARRIED, FREEFORM, SHOOT}

const BOUNCINESS := 0.8 # 球弹跳系数
const HIGH_PASS_DISTANCE_THRESHOLD := 130.0 # 高空传球距离阈值
const KICKOFF_PASS_DISTANCE := 30.0 # 开球传球距离
const PASS_LOCK_DURATION := 500.0 # 传球锁定时间
const TUMBLE_LOCK_DURATION := 200.0 # 滚球锁定时间
const TUMBLE_V_VELOCITY := 3.0 # 滚球速度

@export var friction_air: float
@export var friction_ground: float

@onready var shoot_particles: GPUParticles2D = $ShootParticles
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ball_sprite: Sprite2D = $BallSprite
@onready var player_detection_area: Area2D = $PlayerDetectionArea
@onready var scoring_ray_cast: RayCast2D = $ScoringRayCast
@onready var player_proximity_area: Area2D = $PlayerProximityArea

var carrier: Player = null
var current_state: BallStateBase = null
var height := 0.0
var spawn_position := Vector2.ZERO
var state_factory := BallStateFactory.new()
var velocity := Vector2.ZERO
var v_velocity := 0.0


func _ready() -> void:
	EventBus.ball_state_transition_requested.connect(switch_state.bind())
	switch_state(Ball.State.FREEFORM)
	spawn_position = position
	EventBus.team_reset.connect(_on_team_reset.bind())
	EventBus.kickoff_started.connect(_on_kickoff_started.bind())

func _process(_delta: float) -> void:
	ball_sprite.position = Vector2.UP * height

	scoring_ray_cast.enabled = velocity != Vector2.ZERO
	scoring_ray_cast.rotation = velocity.angle()


func switch_state(state: Ball.State, state_data: BallStateData = BallStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()

	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, ball_sprite, carrier, state_data, animation_player, player_detection_area, shoot_particles)
	current_state.name = "BallStateMachine: " + str(state)

	call_deferred("add_child", current_state)


func shoot(shoot_velocity: Vector2) -> void:
	velocity = shoot_velocity
	carrier = null
	switch_state(Ball.State.SHOOT)


func tumble(tumble_velocity: Vector2) -> void:
	velocity = tumble_velocity
	carrier = null
	v_velocity = TUMBLE_V_VELOCITY
	switch_state(Ball.State.FREEFORM, BallStateData.build().set_lock_duration(TUMBLE_LOCK_DURATION))


func pass_to(destination: Vector2, lock_duration: float = PASS_LOCK_DURATION) -> void:
	var direction := position.direction_to(destination)
	var distance := position.distance_to(destination)
	var h_velocity := sqrt(2 * distance * friction_ground)
	velocity = direction * h_velocity

	# 高空传球不使用 '2' 作为抛物线公式，而是使用 '1.85' 作为抛物线公式
	# 因为需要球在空中飞行的时间更长，落在球员头顶的位置施展 '倒挂金钩' 而非脚下，所以需要更小的抛物线公式
	# '1.85' 是根据实际测试得出的一个经验值，可以调整以适应不同的游戏需求，
	# 如果需要球在空中飞行的时间更短，可以调整这个值为 '2' 或更大
	if distance > HIGH_PASS_DISTANCE_THRESHOLD:
		v_velocity = BallStateBase.GRAVITY * distance / (1.85 * h_velocity)

	carrier = null
	switch_state(Ball.State.FREEFORM, BallStateData.build().set_lock_duration(lock_duration))


func stop() -> void:
	velocity = Vector2.ZERO


func can_air_interact() -> bool:
	return current_state != null and current_state.can_air_interact()


func can_air_connect(air_connect_min_height: float, air_connect_max_height: float) -> bool:
	return height >= air_connect_min_height and height <= air_connect_max_height


func is_headed_for_scoring_area(scoring_area: Area2D) -> bool:
	if not scoring_ray_cast.is_colliding():
		return false

	return scoring_ray_cast.get_collider() == scoring_area


func get_proximity_teammates_count(country:String)-> int:
	var players:=player_proximity_area.get_overlapping_bodies()
	return players.filter(
		func(p:Player) :
			return p.country == country
	).size()


func _on_team_reset() -> void:
	position = spawn_position
	height = 0.0
	v_velocity = 0.0
	velocity = Vector2.ZERO
	carrier = null
	switch_state(Ball.State.FREEFORM)


func _on_kickoff_started() -> void:
	pass_to(spawn_position + Vector2.DOWN * KICKOFF_PASS_DISTANCE, 0)