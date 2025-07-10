class_name BallStateFactory
extends Node

var states: Dictionary = {}


func _init() -> void:
	states = {
		Ball.State.CARRIED: BallStateCarried,
		Ball.State.FREEFORM: BallStateFreeform,
		Ball.State.SHOOT: BallStateShoot,
	}


func get_fresh_state(state: Ball.State) -> BallStateBase:
	assert(states.has(state), "State not found: %s" % state)

	return states.get(state).new()