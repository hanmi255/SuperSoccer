class_name Goal
extends Node2D

@onready var back_net_area: Area2D = $BackNetArea
@onready var targets: Node2D = $Targets


func _ready() -> void:
	back_net_area.body_entered.connect(_on_back_net_area_body_entered.bind())


func get_random_target_position() -> Vector2:
	return targets.get_child(randi_range(0, targets.get_child_count() - 1)).global_position


func get_center_target_position() -> Vector2:
	return targets.get_child(int(targets.get_child_count() / 2.0)).global_position


func _on_back_net_area_body_entered(ball: Ball) -> void:
	ball.stop()
