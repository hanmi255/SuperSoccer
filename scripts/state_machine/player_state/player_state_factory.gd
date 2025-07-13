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
		Player.State.PASSING: PlayerStatePassing,
		Player.State.HEADER: PlayerStateHeader,
		Player.State.VOLLEY_KICK: PlayerStateVolleyKick,
		Player.State.BICYCLE_KICK: PlayerStateBicycleKick,
		Player.State.CHEST_CONTROL: PlayerStateChestControl,
		Player.State.HURT: PlayerStateHurt,
	}


func get_fresh_state(state: Player.State) -> PlayerStateBase:
	assert(states.has(state), "State not found: %s" % state)

	return states.get(state).new()
