class_name BallStateFreeform
extends BallStateBase


func _enter_tree() -> void:
	player_detection_area.body_entered.connect(_on_player_entered.bind())


func _on_player_entered(body: Player) -> void:
	ball.carrier = body
	state_transition_requested.emit(Ball.State.CARRIED)