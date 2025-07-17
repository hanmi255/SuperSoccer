class_name Goal
extends Node2D

@onready var back_net_area: Area2D = $BackNetArea
@onready var targets: Node2D = $Targets
@onready var scoring_area: Area2D = $ScoringArea

var country := ""


func _ready() -> void:
	back_net_area.body_entered.connect(_on_back_net_area_body_entered.bind())
	scoring_area.body_entered.connect(_on_scoring_area_body_entered.bind())


func initialize(context_country: String) -> void:
	country = context_country


func get_random_target_position() -> Vector2:
	return targets.get_child(randi_range(0, targets.get_child_count() - 1)).global_position


func get_top_target_position() -> Vector2:
	return targets.get_child(0).global_position


func get_center_target_position() -> Vector2:
	return targets.get_child(int(targets.get_child_count() / 2.0)).global_position


func get_bottom_target_position() -> Vector2:
	return targets.get_child(targets.get_child_count() - 1).global_position


func get_scoring_area() -> Area2D:
	return scoring_area


func _on_back_net_area_body_entered(ball: Ball) -> void:
	ball.stop()


func _on_scoring_area_body_entered(_ball: Ball) -> void:
	AudioPlayer.play(AudioPlayer.Sound.WHISTLE)
	EventBus.team_scored.emit(country)
