class_name ScoreHelper


static func get_score_text(score: Array[int]) -> String:
	return "%d - %d" % [score[0], score[1]]


static func get_current_score_info(countries: Array[String], score: Array[int]) -> String:
	if score[0] == score[1]:
		return "TEAMS ARE TIED %d - %d" % [score[0], score[1]]

	var leading_team = countries[0] if score[0] > score[1] else countries[1]
	var leading_score = max(score[0], score[1])
	var trailing_score = min(score[0], score[1])

	return "TEAM %s LEADS %d - %d" % [leading_team, leading_score, trailing_score]


static func get_final_score_info(countries: Array[String], score: Array[int]) -> String:
	var leading_team = countries[0] if score[0] > score[1] else countries[1]
	var leading_score = max(score[0], score[1])
	var trailing_score = min(score[0], score[1])

	return "TEAM %s WINS %d - %d" % [leading_team, leading_score, trailing_score]
