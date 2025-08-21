class_name PlayerStateDiving
extends PlayerStateBase

const DIVE_DURATION := 500 # 扑球持续时间

var time_start_dive := 0.0


func _enter_tree() -> void:
	var target_dive := Vector2(player.spawn_position.x, ball.position.y)
	var direction := player.position.direction_to(target_dive)
	if direction.y > 0:
		animation_player.play("dive_down")
	else:
		animation_player.play("dive_up")

	player.velocity = direction * player.speed
	time_start_dive = Time.get_ticks_msec()


func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_start_dive > DIVE_DURATION:
		transition_to_state(Player.State.RECOVERING)