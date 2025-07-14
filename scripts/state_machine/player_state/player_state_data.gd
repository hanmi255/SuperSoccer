# 使用建造者模式构建数据对象
class_name PlayerStateData

var hurt_direction: Vector2
var pass_target: Player
var shoot_direction: Vector2
var shoot_power: float


static func build() -> PlayerStateData:
	return PlayerStateData.new()


func set_hurt_direction(direction: Vector2) -> PlayerStateData:
	hurt_direction = direction
	return self


func set_pass_target(target: Player) -> PlayerStateData:
	pass_target = target
	return self


func set_shoot_direction(direction: Vector2) -> PlayerStateData:
	shoot_direction = direction
	return self


func set_shoot_power(power: float) -> PlayerStateData:
	shoot_power = power
	return self
