class_name Goal
extends Node2D

@onready var back_net_area: Area2D = $BackNetArea


func _on_back_net_area_body_entered(ball: Ball) -> void:
	ball.stop()
