## 按键输入工具
## 管理玩家输入控制映射并提供简化的输入检测接口
class_name KeyUtils

## 定义游戏中的基本动作类型
enum Action {LEFT, RIGHT, UP, DOWN, SHOOT, PASS, SWAP_SOUL}

## 控制方案映射字典
## 将不同玩家的控制方案映射到具体的输入动作
const ACTIONS_MAP: Dictionary = {
	Player.ControlScheme.P1: {
		Action.LEFT: "p1_left",
		Action.RIGHT: "p1_right",
		Action.UP: "p1_up",
		Action.DOWN: "p1_down",
		Action.SHOOT: "p1_shoot",
		Action.PASS: "p1_pass",
		Action.SWAP_SOUL: "p1_swap_soul",
	}, # P1控制方案
	Player.ControlScheme.P2: {
		Action.LEFT: "p2_left",
		Action.RIGHT: "p2_right",
		Action.UP: "p2_up",
		Action.DOWN: "p2_down",
		Action.SHOOT: "p2_shoot",
		Action.PASS: "p2_pass",
		Action.SWAP_SOUL: "p2_swap_soul",
	}, # P2控制方案
} # 控制方案映射字典


## 获取指定控制方案的方向输入向量
## 参数:
##   control_scheme - 玩家的控制方案(P1或P2)
## 返回:
##   基于当前按键输入的标准化二维向量
static func get_input_vector(control_scheme: Player.ControlScheme) -> Vector2:
	var map: Dictionary = ACTIONS_MAP[control_scheme]
	return Input.get_vector(map[Action.LEFT], map[Action.RIGHT], map[Action.UP], map[Action.DOWN])


## 检查指定动作是否被按下
## 参数:
##   control_scheme - 玩家的控制方案
##   action - 要检查的动作类型
## 返回:
##   如果动作当前被按下则返回true
static func is_action_pressed(control_scheme: Player.ControlScheme, action: Action) -> bool:
	return Input.is_action_pressed(ACTIONS_MAP[control_scheme][action])


## 检查指定动作是否刚被按下(本帧按下，上一帧未按下)
## 参数:
##   control_scheme - 玩家的控制方案
##   action - 要检查的动作类型
## 返回:
##   如果动作刚被按下则返回true
static func is_action_just_pressed(control_scheme: Player.ControlScheme, action: Action) -> bool:
	return Input.is_action_just_pressed(ACTIONS_MAP[control_scheme][action])


## 检查指定动作是否刚被释放(本帧未按下，上一帧按下)
## 参数:
##   control_scheme - 玩家的控制方案
##   action - 要检查的动作类型
## 返回:
##   如果动作刚被释放则返回true
static func is_action_just_released(control_scheme: Player.ControlScheme, action: Action) -> bool:
	return Input.is_action_just_released(ACTIONS_MAP[control_scheme][action])
