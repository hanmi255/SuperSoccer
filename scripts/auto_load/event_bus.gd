extends Node

signal ball_state_transition_requested(new_state: Ball.State, data: BallStateData)
signal game_state_transition_requested(new_state: GameManager.State, data: GameStateData)
signal player_state_transition_requested(target_player: Player, new_state: Player.State, data: PlayerStateData)
signal swap_soul_requested(requester: Player)
signal team_scored(country_scored_for: String)
