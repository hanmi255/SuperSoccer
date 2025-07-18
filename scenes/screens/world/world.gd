class_name World
extends ScreenStateBase

@onready var game_over_timer: Timer = $GameOverTimer


func _ready() -> void:
	game_over_timer.timeout.connect(_on_transition.bind())
	EventBus.game_over.connect(_on_game_over.bind())
	GameManager.start_game()


func _on_game_over(_winner: String) -> void:
	game_over_timer.start()


func _on_transition() -> void:
	if screen_data.tournament_data == null:
		transition_to_state(SoccerGame.ScreenType.MAIN_MENU)
		return

	if GameManager.current_match.winner != GameManager.player_setup[0]:
		transition_to_state(SoccerGame.ScreenType.MAIN_MENU)
		return

	screen_data.tournament_data.advance()
	transition_to_state(SoccerGame.ScreenType.TOURNAMENT, screen_data)