class_name ActorsContainer
extends Node2D

const PLAYER_SCENE := preload("res://scenes/player/player.tscn") # 球员场景
const WEIGHT_CACHE_DURATION := 200.0 # 权重缓存时间
const MAX_WEIGHT_FACTOR := 10.0 # 权重计算的最大因子
const WEIGHT_EASE_CURVE := 0.1 # 权重曲线参数，用于控制权重随距离变化的平滑度

@export var ball: Ball
@export var goal_home: Goal
@export var goal_away: Goal

@onready var spawns: Node2D = $Spawns
@onready var kick_offs: Node2D = $KickOffs
@onready var players_container: Node2D = $PlayersContainer

var is_checking_for_kickoff_readiness := false
var squad_home: Array[Player] = []
var squad_away: Array[Player] = []
var team_home := GameManager.get_home_team()
var team_away := GameManager.get_away_team()
var time_since_last_cache_refresh := 0.0


func _ready() -> void:
	EventBus.swap_soul_requested.connect(_on_player_swap_soul_requested.bind())
	squad_home = spawn_players(team_home, goal_home)
	goal_home.initialize(team_home)
	spawns.scale.x = -1
	kick_offs.scale.x = -1
	squad_away = spawn_players(team_away, goal_away)
	goal_away.initialize(team_away)

	time_since_last_cache_refresh = Time.get_ticks_msec()

	# 添加可控制测试球员
	var player_test: Player = players_container.get_child(4)
	player_test.control_scheme = Player.ControlScheme.P1
	player_test.set_control_scheme_sprite()

	EventBus.team_reset.connect(_on_team_reset.bind())


func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_since_last_cache_refresh > WEIGHT_CACHE_DURATION:
		time_since_last_cache_refresh = Time.get_ticks_msec()
		set_on_duty_weights()

	if is_checking_for_kickoff_readiness:
		check_for_kickoff_readiness()


func spawn_players(country: String, own_goal: Goal) -> Array[Player]:
	# 获取球队数据
	var squad := DataLoader.get_squad(country)
	var players: Array[Player] = []

	# 设置目标球门，如果当前球门是主场球门，则目标球门是客场球门，反之亦然
	var target_goal := goal_away if own_goal == goal_home else goal_home

	# 遍历球队数据，生成球员
	for i in squad.size():
		var player_pos := spawns.get_child(i).global_position as Vector2
		var player_data := squad[i] as PlayerResource
		var kickoff_pos := player_pos

		# 为前锋设置开球位置
		if i > 3:
			kickoff_pos = kick_offs.get_child(i - 4).global_position as Vector2

		var player := spawn_player(player_pos, kickoff_pos, own_goal, target_goal, player_data, country)
		players.append(player)
		players_container.add_child(player)

	return players


func spawn_player(player_pos: Vector2, kickoff_position: Vector2, own_goal: Goal, target_goal: Goal, player_data: PlayerResource, country: String) -> Player:
	var player := PLAYER_SCENE.instantiate()
	player.initialize(player_pos, kickoff_position, ball, own_goal, target_goal, player_data, country)

	return player


func set_on_duty_weights() -> void:
	for squad in [squad_home, squad_away]:
		# 过滤非守门员的CPU
		var cpu_players: Array[Player] = squad.filter(
			func(p: Player): return p.control_scheme == Player.ControlScheme.CPU and p.role != Player.Role.GOALIE
		)
		# 根据出生点与球的当前位置距离排序
		cpu_players.sort_custom(
			func(a: Player, b: Player): return a.spawn_position.distance_squared_to(ball.position) < b.spawn_position.distance_squared_to(ball.position)
		)
		# 设置指数级递减的权重
		var squad_size := cpu_players.size()
		for i in range(squad_size):
			cpu_players[i].weight_on_duty_steering = 1.0 - ease(float(i) / MAX_WEIGHT_FACTOR, WEIGHT_EASE_CURVE)


func check_for_kickoff_readiness() -> void:
	for squad in [squad_home, squad_away]:
		for player: Player in squad:
			if not player.is_ready_for_kickoff():
				return

	is_checking_for_kickoff_readiness = false
	EventBus.kickoff_ready.emit()


func _on_player_swap_soul_requested(requester: Player) -> void:
	var squad_to_swap := squad_home if requester.country == team_home else squad_away
	# 过滤非守门员的CPU
	var cpu_players: Array[Player] = squad_to_swap.filter(
		func(p: Player): return p.control_scheme == Player.ControlScheme.CPU and p.role != Player.Role.GOALIE
	)
	# 根据与请求者的距离排序
	cpu_players.sort_custom(
		func(a: Player, b: Player): return a.position.distance_squared_to(requester.position) < b.position.distance_squared_to(requester.position)
	)
	var target_player := cpu_players[0]
	# 如果目标球员距离球更近，则交换灵魂
	if target_player.position.distance_squared_to(ball.position) < requester.position.distance_squared_to(ball.position):
		var player_control_scheme := requester.control_scheme
		requester.control_scheme = target_player.control_scheme
		requester.set_control_scheme_sprite()
		target_player.control_scheme = player_control_scheme
		target_player.set_control_scheme_sprite()


func _on_team_reset() -> void:
	is_checking_for_kickoff_readiness = true