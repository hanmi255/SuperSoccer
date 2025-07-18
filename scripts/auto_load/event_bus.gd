extends Node

signal ball_possessed(player_name: String)
signal ball_released
signal ball_state_transition_requested(new_state: Ball.State, data: BallStateData)
signal flag_selected()
signal game_over(winner: String)
signal game_state_transition_requested(new_state: GameManager.State, data: GameStateData)
signal impact_received(impact_pos: Vector2, is_high_impact: bool)
signal kickoff_ready
signal kickoff_started
signal player_state_transition_requested(target_player: Player, new_state: Player.State, data: PlayerStateData)
signal score_changed
signal screen_state_transition_requested(new_state: SoccerGame.ScreenType, data: ScreenStateData)
signal swap_soul_requested(requester: Player)
signal team_reset
signal team_scored(country_scored_on: String)
