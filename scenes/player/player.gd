class_name Player
extends CharacterBody2D

enum ControlScheme {CPU, P1, P2}
enum Role {GOALIE, DEFENDER, MIDFIELDER, FORWARD}
enum SkinColor {LIGHT, MEDIUM, DARK}
enum State {MOVING, TACKLING, RECOVERING, PREPPING_SHOOT, SHOOTING, PASSING, HEADER, VOLLEY_KICK, BICYCLE_KICK, CHEST_CONTROL}

const CONTROL_SCHEME_SPRITE_MAP := {
	ControlScheme.CPU: preload("res://assets/sprites/props/cpu.png"),
	ControlScheme.P1: preload("res://assets/sprites/props/1p.png"),
	ControlScheme.P2: preload("res://assets/sprites/props/2p.png"),
}

const GRAVITY := 8.0
const BALL_CONTROL_HEIGHT_MAX := 10.0

@export var ball: Ball = null
@export var control_scheme: ControlScheme
@export var power: float = 70.0
@export var speed: float = 80.0
@export var own_goal: Goal = null
@export var target_goal: Goal = null

@onready var skin: Sprite2D = $Skin
@onready var control_sprite: Sprite2D = %ControlSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var teammate_detection_area: Area2D = $TeammateDetectionArea
@onready var ball_detection_area: Area2D = $BallDetectionArea

var current_state: PlayerStateBase = null
var full_name := ""
var heading := Vector2.RIGHT
var height := 0.0
var role := Player.Role.DEFENDER
var skin_color := Player.SkinColor.LIGHT
var state_factory := PlayerStateFactory.new()
var v_velocity := 0.0


func _ready() -> void:
	_set_control_scheme_sprite()
	switch_state(Player.State.MOVING)


func _process(delta: float) -> void:
	_flip_skin()
	_set_control_scheme_sprite_visibility()
	_apply_gravity(delta)
	move_and_slide()


func initialize(context_player_pos: Vector2, context_ball: Ball, context_own_goal: Goal, context_target_goal: Goal, context_player_data: PlayerResource) -> void:
	position = context_player_pos
	ball = context_ball
	own_goal = context_own_goal
	target_goal = context_target_goal
	full_name = context_player_data.full_name
	role = context_player_data.role
	skin_color = context_player_data.skin_color
	speed = context_player_data.speed
	power = context_player_data.power
	heading = Vector2.LEFT if target_goal.position.x < position.x else Vector2.RIGHT


func switch_state(state: Player.State, state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()

	current_state = state_factory.get_fresh_state(state)

	current_state.setup(self, ball, state_data, animation_player, teammate_detection_area, ball_detection_area, own_goal, target_goal)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "PlayerStateMachine: " + str(state)

	call_deferred("add_child", current_state)


func set_movement_animation() -> void:
	animation_player.play("run" if velocity.length() > 0 else "idle")


func set_heading() -> void:
	if velocity.x != 0: # 只在玩家实际水平移动时更新方向
		heading = Vector2.RIGHT if velocity.x > 0 else Vector2.LEFT


func is_carrying_ball() -> bool:
	return ball.carrier == self


func control_ball() -> void:
	if ball.height > BALL_CONTROL_HEIGHT_MAX:
		switch_state(Player.State.CHEST_CONTROL)


func _flip_skin() -> void:
	skin.flip_h = heading == Vector2.LEFT


func _set_control_scheme_sprite() -> void:
	control_sprite.texture = CONTROL_SCHEME_SPRITE_MAP[control_scheme]


func _apply_gravity(delta: float) -> void:
	if height > 0:
		v_velocity -= GRAVITY * delta
		height += v_velocity
		height = max(0, height)

	skin.position = Vector2.UP * height


func _set_control_scheme_sprite_visibility() -> void:
	control_sprite.visible = is_carrying_ball() or control_scheme != ControlScheme.CPU


func on_animation_finished() -> void:
	if current_state != null:
		current_state.on_animation_finished()
