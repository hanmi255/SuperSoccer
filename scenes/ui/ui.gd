class_name UI
extends CanvasLayer

@onready var flag_textures: Array[TextureRect] = [%HomeFlagTexture, %AwayFlagTexture]
@onready var player_label: Label = %PlayerLabel
@onready var score_label: Label = %ScoreLabel
@onready var time_label: Label = %TimeLabel
@onready var goal_scorer_label: Label = %GoalScorerLabel
@onready var score_info_label: Label = %ScoreInfoLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var last_ball_carrier := ""


func _ready() -> void:
	_update_score()
	_update_flags()
	_updata_clock()
	player_label.text = ""

	EventBus.ball_possessed.connect(_on_ball_possessed.bind())
	EventBus.ball_released.connect(_on_ball_released.bind())
	EventBus.score_changed.connect(_on_score_changed.bind())
	EventBus.team_reset.connect(_on_team_reset.bind())
	EventBus.game_over.connect(_on_game_over.bind())


func _process(_delta: float) -> void:
	_updata_clock()


func _update_score() -> void:
	score_label.text = ScoreHelper.get_score_text(GameManager.current_match)


func _update_flags() -> void:
	for i in flag_textures.size():
		var countries := [GameManager.get_home_team(), GameManager.get_away_team()]
		flag_textures[i].texture = FlagHelper.get_flag_texture(countries[i])


func _updata_clock() -> void:
	if GameManager.time_left < 0:
		time_label.modulate = Color.YELLOW
	time_label.text = TimeHelper.get_time_text(GameManager.time_left)


func _on_ball_possessed(player_name: String) -> void:
	player_label.text = player_name
	last_ball_carrier = player_name


func _on_ball_released() -> void:
	player_label.text = ""


func _on_score_changed() -> void:
	if not GameManager.is_time_up():
		goal_scorer_label.text = "%s JUST SCORED!" % last_ball_carrier
		score_info_label.text = ScoreHelper.get_current_score_info(GameManager.current_match)
		animation_player.play("goal_appear")
	_update_score()


func _on_team_reset() -> void:
	if GameManager.current_match.has_someone_scored():
		animation_player.play("goal_hide")


func _on_game_over(_winner: String) -> void:
	score_info_label.text = ScoreHelper.get_final_score_info(GameManager.current_match)
	animation_player.play("game_over")
