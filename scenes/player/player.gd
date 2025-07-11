class_name Player
extends CharacterBody2D

enum ControlScheme {CPU, P1, P2}
enum State {MOVING, TACKLING, RECOVERING, PREPPING_SHOOT, SHOOTING, PASSING}

const CONTROL_SCHEME_SPRITE_MAP := {
	ControlScheme.CPU: preload("res://assets/sprites/props/cpu.png"),
	ControlScheme.P1: preload("res://assets/sprites/props/1p.png"),
	ControlScheme.P2: preload("res://assets/sprites/props/2p.png"),
}

@export var ball: Ball = null
@export var control_scheme: ControlScheme = ControlScheme.P1
@export var power: float = 70.0
@export var speed: float = 80.0

@onready var skin: Sprite2D = $Skin
@onready var control_sprite: Sprite2D = %ControlSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var teammate_detection_area: Area2D = $TeammateDetectionArea

var current_state: PlayerStateBase = null
var heading := Vector2.RIGHT
var state_factory := PlayerStateFactory.new()


func _ready() -> void:
	_set_control_scheme_sprite()
	switch_state(Player.State.MOVING)

func _process(_delta: float) -> void:
	_flip_skin()
	_set_control_scheme_sprite_visibility()
	move_and_slide()

func switch_state(state: Player.State, state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()

	current_state = state_factory.get_fresh_state(state)

	current_state.setup(self, ball, state_data, animation_player, teammate_detection_area)
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


func _flip_skin() -> void:
	skin.flip_h = heading == Vector2.LEFT


func _set_control_scheme_sprite() -> void:
	control_sprite.texture = CONTROL_SCHEME_SPRITE_MAP[control_scheme]


func _set_control_scheme_sprite_visibility() -> void:
	control_sprite.visible = is_carrying_ball() or control_scheme != ControlScheme.CPU


func on_animation_finished() -> void:
	if current_state != null:
		current_state.on_animation_finished()
