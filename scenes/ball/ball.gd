class_name Ball
extends AnimatableBody2D

enum State {CARRIED, FREEFORM, SHOOT}

const BOUNCINESS := 0.8

@export var friction_air: float
@export var friction_ground: float

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ball_sprite: Sprite2D = $BallSprite
@onready var player_detection_area: Area2D = $PlayerDetectionArea

var carrier: Player = null
var current_state: BallStateBase = null
var height := 0.0
var height_velocity := 0.0
var state_factory := BallStateFactory.new()
var velocity := Vector2.ZERO


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
	var intensity := sqrt(2 * distance * friction_ground)
	velocity = direction * intensity
	carrier = null
	switch_state(Ball.State.FREEFORM)


func stop() -> void:
	velocity = Vector2.ZERO