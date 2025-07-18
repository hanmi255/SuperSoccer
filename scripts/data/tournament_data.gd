class_name TournamentData

enum Stage {QUARTER_FINALS, SEMI_FINALS, FINAL, COMPLETE}

var current_stage: Stage = Stage.QUARTER_FINALS
var matches := {
	Stage.QUARTER_FINALS: [],
	Stage.SEMI_FINALS: [],
	Stage.FINAL: [],
}
var winner := ""


func _init() -> void:
	var all_countries := DataLoader.get_countries()
	var selected_countries: Array[String] = []

	# 确保玩家选择的国家包含在锦标赛中
	var player_country := GameManager.player_setup[0]
	if not player_country.is_empty():
		selected_countries.append(player_country)
		# 从所有国家中移除玩家选择的国家，避免重复
		all_countries.erase(player_country)

	# 随机选择剩余的7个国家
	all_countries.shuffle()
	var remaining_countries := all_countries.slice(0, 7)
	selected_countries.append_array(remaining_countries)

	# 打乱最终的8个国家顺序
	selected_countries.shuffle()
	_create_bracket(Stage.QUARTER_FINALS, selected_countries)


func _create_bracket(stage: Stage, countries: Array[String]) -> void:
	for i in range(int(countries.size() / 2.0)):
		matches[stage].append(Match.new(countries[i * 2], countries[i * 2 + 1]))


func advance() -> void:
	if current_stage < Stage.COMPLETE:
		var stage_matches: Array = matches[current_stage]
		var stage_winners: Array[String] = []
		for current_match: Match in stage_matches:
			current_match.resolve()
			stage_winners.append(current_match.winner)

		current_stage = current_stage + 1 as Stage
		if current_stage == Stage.COMPLETE:
			winner = stage_winners[0]
		else:
			_create_bracket(current_stage, stage_winners)