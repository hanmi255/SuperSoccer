class_name BallStateCarried
extends BallStateBase


func _enter_tree() -> void:
	assert(carrier != null)


func _process(_delta: float) -> void:
	ball.position = carrier.position
