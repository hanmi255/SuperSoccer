class_name Player
extends CharacterBody2D

enum ControlScheme {CPU, P1, P2}
enum State {MOVING, TACKLING, RECOVERING, PREPPING_SHOOT, SHOOTING}

@export var ball: Ball = null
@export var control_scheme: ControlScheme = ControlScheme.P1
@export var power: float = 70.0
@export var speed: float = 80.0

@onready var skin: Sprite2D = $Skin
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_state: PlayerStateBase = null
var heading := Vector2.RIGHT
var state_factory := PlayerStateFactory.new()


func _ready() -> void:
	switch_state(Player.State.MOVING)


func _process(_delta: float) -> void:
	_flip_skin()
	move_and_slide()


func switch_state(state: Player.State, state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()

	current_state = state_factory.get_fresh_state(state)

	current_state.setup(self, ball, state_data, animation_player)
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


func on_animation_finished() -> void:
	if current_state != null:
		current_state.on_animation_finished()


func _flip_skin() -> void:
	skin.flip_h = heading == Vector2.LEFT
