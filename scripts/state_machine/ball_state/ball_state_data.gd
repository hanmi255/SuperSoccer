# 使用建造者模式构建数据对象
class_name BallStateData

var lock_duration: float


static func build() -> BallStateData:
	return BallStateData.new()


func set_lock_duration(duration: float) -> BallStateData:
	lock_duration = duration
	return self
