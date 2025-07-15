extends Node

signal player_state_transition_requested(target_player: Player, new_state: Player.State, data: PlayerStateData)
signal ball_state_transition_requested(new_state: Ball.State, data: BallStateData)
signal swap_soul_requested(requester: Player)
signal team_scored(country_scored_for: String)
