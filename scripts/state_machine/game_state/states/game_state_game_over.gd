class_name GameStateGameOver
extends GameStateBase


func _enter_tree() -> void:
	var winner := manager.get_winner()
	EventBus.game_over.emit(winner)