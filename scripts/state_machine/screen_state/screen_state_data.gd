class_name ScreenStateData

var tournament_data: TournamentData = null

static func build() -> ScreenStateData:
	return ScreenStateData.new()


func set_tournament(context_tournament_data: TournamentData) -> ScreenStateData:
	tournament_data = context_tournament_data
	return self