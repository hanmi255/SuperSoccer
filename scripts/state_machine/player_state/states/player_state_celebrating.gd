class_name PlayerStateCelebrating
extends PlayerStateBase

const AIR_FRICTION := 35.0
const CELEBRATE_V_VELOCITY := 2.0


func _enter_tree() -> void:
	_celebrate()
	EventBus.team_reset.connect(_on_team_reset)


func _process(delta: float) -> void:
	if player.height <= 0:
		_celebrate()

	player.velocity = player.velocity.move_toward(Vector2.ZERO, AIR_FRICTION * delta)


func _celebrate() -> void:
	animation_player.play("celebrate")
	player.height = 0.1
	player.v_velocity = CELEBRATE_V_VELOCITY


func _on_team_reset() -> void:
	transition_to_state(Player.State.RESETTING, PlayerStateData.build().set_reset_position(player.spawn_position))