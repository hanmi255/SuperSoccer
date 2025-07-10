class_name Ball
extends AnimatableBody2D

enum State {CARRIED, FREEFORM, SHOOT}

@onready var player_detection_area: Area2D = $PlayerDetectionArea

var carrier: Player = null
var current_state: BallStateBase = null
var state_factory := BallStateFactory.new()
var velocity := Vector2.ZERO


func _ready() -> void:
	switch_state(State.FREEFORM)


func switch_state(state: State) -> void:
	if current_state != null:
		current_state.queue_free()

	current_state = state_factory.get_fresh_state(state)

	current_state.setup(self, carrier, player_detection_area)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "BallStateMachine: " + str(state)

	call_deferred("add_child", current_state)