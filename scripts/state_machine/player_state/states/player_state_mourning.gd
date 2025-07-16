class_name PlayerStateMourning
extends PlayerStateBase


func _enter_tree() -> void:
	animation_player.play("mourn")
	player.velocity = Vector2.ZERO
	EventBus.team_reset.connect(_on_team_reset)


func _on_team_reset() -> void:
	transition_to_state(Player.State.RESETTING, PlayerStateData.build().set_reset_position(player.kickoff_position))