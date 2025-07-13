class_name ActorsContainer
extends Node2D

const PLAYER_SCENE := preload("res://scenes/player/player.tscn")

@export var ball: Ball
@export var goal_home: Goal
@export var goal_away: Goal
@export var team_home: String
@export var team_away: String

@onready var spawns: Node2D = $Spawns


func _ready() -> void:
	spawn_players(team_home, goal_home)
	spawns.scale.x = -1
	spawn_players(team_away, goal_away)


func spawn_players(team_name: String, own_goal: Goal) -> void:
	var players := LoadData.get_squad(team_name)
	var target_goal := goal_away if own_goal == goal_home else goal_home

	for i in players.size():
		var player_pos := spawns.get_child(i).global_position as Vector2
		var player_data := players[i] as PlayerResource
		var player := spawn_player(player_pos, ball, own_goal, target_goal, player_data)
		add_child(player)


func spawn_player(player_pos: Vector2, ball_ref: Ball, own_goal: Goal, target_goal: Goal, player_data: PlayerResource) -> Player:
	var player := PLAYER_SCENE.instantiate()
	player.initialize(player_pos, ball_ref, own_goal, target_goal, player_data)
	return player
