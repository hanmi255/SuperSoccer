class_name Tournament
extends ScreenStateBase

const STAGE_TEXTURES := {
	TournamentData.Stage.QUARTER_FINALS: preload("res://assets/sprites/ui/team_selection/quarters-label.png"),
	TournamentData.Stage.SEMI_FINALS: preload("res://assets/sprites/ui/team_selection/semis-label.png"),
	TournamentData.Stage.FINAL: preload("res://assets/sprites/ui/team_selection/finals-label.png"),
	TournamentData.Stage.COMPLETE: preload("res://assets/sprites/ui/team_selection/winner-label.png"),
}

@onready var flag_containers: Dictionary = {
	TournamentData.Stage.QUARTER_FINALS: [%QuarterFinalLeftContainer, %QuarterFinalRightContainer],
	TournamentData.Stage.SEMI_FINALS: [%SemiFinalLeftContainer, %SemiFinalRightContainer],
	TournamentData.Stage.FINAL: [%FinalLeftContainer, %FinalRightContainer],
	TournamentData.Stage.COMPLETE: [%WinnerContainer]
}
@onready var stage_texture: TextureRect = %StageTexture

var player_country := GameManager.player_setup[0]
var tournament_data: TournamentData = null


func _ready() -> void:
	tournament_data = TournamentData.new()
	_refresh_brackets()


func _process(_delta: float) -> void:
	if KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.SHOOT):
		tournament_data.advance()
		_refresh_brackets()


func _refresh_brackets() -> void:
	for stage in range(tournament_data.current_stage + 1):
		_refresh_bracket_state(stage)


func _refresh_bracket_state(stage: TournamentData.Stage) -> void:
	var flag_nodes := _get_flag_nodes_from_stage(stage)
	stage_texture.texture = STAGE_TEXTURES.get(stage)

	if stage < TournamentData.Stage.COMPLETE:
		var matches: Array = tournament_data.matches[stage]

		assert(flag_nodes.size() == 2 * matches.size())

		for i in range(matches.size()):
			var current_match: Match = matches[i]
			var flag_home: BracketFlag = flag_nodes[i * 2]
			var flag_away: BracketFlag = flag_nodes[i * 2 + 1]
			_set_flag_texture(flag_home, current_match.country_home)
			_set_flag_texture(flag_away, current_match.country_away)

			if not current_match.winner.is_empty():
				var flag_winner := flag_home if current_match.winner == current_match.country_home else flag_away
				var flag_loser := flag_home if flag_winner == flag_away else flag_away
				flag_winner.set_as_winner(current_match.final_score)
				flag_loser.set_as_loser()

			elif [current_match.country_home, current_match.country_away].has(player_country):
				var flag_player := flag_home if current_match.country_home == player_country else flag_away
				flag_player.set_as_current_team()
				GameManager.current_match = current_match
	else:
		_set_flag_texture(flag_nodes[0], tournament_data.winner)


func _get_flag_nodes_from_stage(stage: TournamentData.Stage) -> Array[BracketFlag]:
	var flag_nodes: Array[BracketFlag] = []
	var containers = flag_containers.get(stage)

	for container in containers:
		for node in container.get_children():
			if node is BracketFlag:
				flag_nodes.append(node)

	return flag_nodes


func _set_flag_texture(flag: BracketFlag, country: String) -> void:
	flag.texture = FlagHelper.get_flag_texture(country)
