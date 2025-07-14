class_name Player
extends CharacterBody2D

enum ControlScheme {CPU, P1, P2}
enum Role {GOALIE, DEFENDER, MIDFIELDER, FORWARD}
enum SkinColor {LIGHT, MEDIUM, DARK}
enum State {MOVING, TACKLING, RECOVERING, PREPPING_SHOOT, SHOOTING, PASSING, HEADER, VOLLEY_KICK, BICYCLE_KICK, CHEST_CONTROL, HURT, DIVING}

const CONTROL_SCHEME_SPRITE_MAP := {
	ControlScheme.CPU: preload("res://assets/sprites/props/cpu.png"),
	ControlScheme.P1: preload("res://assets/sprites/props/1p.png"),
	ControlScheme.P2: preload("res://assets/sprites/props/2p.png"),
} # 控制方案精灵映射
const COUNTRIES := ["FRANCE", "ARGENTINA", "BRAZIL", "ENGLAND", "GERMANY", "ITALY", "SPAIN", "USA", "CANADA"] # 国家列表
const GRAVITY := 8.0 # 重力加速度
const BALL_CONTROL_HEIGHT_MAX := 10.0 # 控球高度最大值
const WALK_ANIM_THRESHOLD := 0.6 # 行走动画阈值
const IDLE_SPEED_THRESHOLD := 1.0 # 静止动画阈值

@export var ball: Ball = null
@export var control_scheme: ControlScheme
@export var power: float = 70.0
@export var speed: float = 80.0
@export var own_goal: Goal = null
@export var target_goal: Goal = null

@onready var skin: Sprite2D = $Skin
@onready var goalie_hands_collision: CollisionShape2D = %GoalieHandsCollision
@onready var control_sprite: Sprite2D = %ControlSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var teammate_detection_area: Area2D = $TeammateDetectionArea
@onready var opponent_detection_area: Area2D = $OpponentDetectionArea
@onready var ball_detection_area: Area2D = $BallDetectionArea
@onready var tackle_damage_emitter_area: Area2D = $TackleDamageEmitterArea
@onready var permanent_damage_emitter_area: Area2D = $PermanentDamageEmitterArea

var ai_behavior_factory := AIBehaviorFactory.new()
var country := ""
var current_ai_behavior: AIBehaviorBase = null
var current_state: PlayerStateBase = null
var full_name := ""
var heading := Vector2.RIGHT
var height := 0.0
var role := Player.Role.DEFENDER
var skin_color := Player.SkinColor.LIGHT
var spawn_position := Vector2.ZERO
var state_factory := PlayerStateFactory.new()
var v_velocity := 0.0
var weight_on_duty_steering := 0.0


func _ready() -> void:
	_set_control_scheme_sprite()
	_setup_ai_behavior()
	switch_state(Player.State.MOVING)
	_set_shader_properties()
	permanent_damage_emitter_area.monitoring = role == Role.GOALIE
	goalie_hands_collision.disabled = role != Role.GOALIE
	tackle_damage_emitter_area.body_entered.connect(_on_hurt_player.bind())
	permanent_damage_emitter_area.body_entered.connect(_on_hurt_player.bind())
	spawn_position = position


func _process(delta: float) -> void:
	_flip_skin()
	_set_control_scheme_sprite_visibility()
	_apply_gravity(delta)
	move_and_slide()


func initialize(context_player_pos: Vector2, context_ball: Ball, context_own_goal: Goal, context_target_goal: Goal, context_player_data: PlayerResource, context_country: String) -> void:
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
	country = context_country


func switch_state(state: Player.State, state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()

	current_state = state_factory.get_fresh_state(state)

	current_state.setup(self, ball, state_data, animation_player, teammate_detection_area, opponent_detection_area, ball_detection_area, own_goal, target_goal, tackle_damage_emitter_area, current_ai_behavior)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "PlayerStateMachine: " + str(state)

	call_deferred("add_child", current_state)


func set_movement_animation() -> void:
	var vel_length := velocity.length()
	var anim_name := ""

	if vel_length < IDLE_SPEED_THRESHOLD:
		anim_name = "idle"
	elif vel_length < speed * WALK_ANIM_THRESHOLD:
		anim_name = "walk"
	else:
		anim_name = "run"

	if animation_player.current_animation != anim_name:
		animation_player.play(anim_name)


func set_heading() -> void:
	if velocity.x != 0: # 只在玩家实际水平移动时更新方向
		heading = Vector2.RIGHT if velocity.x > 0 else Vector2.LEFT


func can_carry_ball() -> bool:
	return current_state != null and current_state.can_carry_ball()


func is_carrying_ball() -> bool:
	return ball.carrier == self


func is_facing_target_goal() -> bool:
	var direction_to_target_goal := position.direction_to(target_goal.position)
	return heading.dot(direction_to_target_goal) > 0


func control_ball() -> void:
	if ball.height > BALL_CONTROL_HEIGHT_MAX:
		switch_state(Player.State.CHEST_CONTROL)


func get_pass_request(target: Player) -> void:
	if ball.carrier == self and current_state != null and current_state.can_pass():
		switch_state(Player.State.PASSING, PlayerStateData.build().set_pass_target(target))


func _flip_skin() -> void:
	if heading == Vector2.LEFT:
		skin.flip_h = true
		opponent_detection_area.scale.x = -1
		tackle_damage_emitter_area.scale.x = -1
	elif heading == Vector2.RIGHT:
		skin.flip_h = false
		opponent_detection_area.scale.x = 1
		tackle_damage_emitter_area.scale.x = 1


func _set_control_scheme_sprite() -> void:
	control_sprite.texture = CONTROL_SCHEME_SPRITE_MAP[control_scheme]


func _set_shader_properties() -> void:
	skin.material.set_shader_parameter("team_color", COUNTRIES.find(country))
	skin.material.set_shader_parameter("skin_color", skin_color)


func _apply_gravity(delta: float) -> void:
	if height > 0:
		v_velocity -= GRAVITY * delta
		height += v_velocity
		height = max(0, height)

	skin.position = Vector2.UP * height


func _set_control_scheme_sprite_visibility() -> void:
	control_sprite.visible = is_carrying_ball() or control_scheme != ControlScheme.CPU


func _get_hurt(hurt_direction: Vector2) -> void:
	switch_state(Player.State.HURT, PlayerStateData.build().set_hurt_direction(hurt_direction))


func _setup_ai_behavior() -> void:
	current_ai_behavior = ai_behavior_factory.get_ai_behavior(role)
	current_ai_behavior.setup(self, ball, opponent_detection_area, teammate_detection_area)
	current_ai_behavior.name = "AI Behavior"
	add_child(current_ai_behavior)


func _on_hurt_player(body: Node2D) -> void:
	if body != self and body.country != country and body == ball.carrier:
		body._get_hurt(position.direction_to(body.position))


func on_animation_finished() -> void:
	if current_state != null:
		current_state.on_animation_finished()
