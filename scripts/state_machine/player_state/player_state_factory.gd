class_name PlayerStateFactory
extends Node

var states: Dictionary = {}


func _init() -> void:
	states = {
		Player.State.MOVING: PlayerStateMoving,
		Player.State.TACKLING: PlayerStateTackling,
		Player.State.RECOVERING: PlayerStateRecovering,
		Player.State.PREPPING_SHOOT: PlayerStatePreppingShoot,
		Player.State.SHOOTING: PlayerStateShooting,
	}


func get_fresh_state(state: Player.State) -> PlayerStateBase:
	assert(states.has(state), "State not found: %s" % state)

	return states.get(state).new()
