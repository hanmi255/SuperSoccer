class_name TeamSelection
extends ScreenStateBase

const FLAG_ANCHOR_POINT := Vector2(65, 70)
const FLAG_SELECTOR := preload("res://scenes/flags_selector/flags_selector.tscn")
const NUM_COLS := 3
const NUM_ROWS := 3

@onready var flags_container: Control = %FlagsContainer

var move_dirs: Dictionary[KeyUtils.Action, Vector2i] = {
	KeyUtils.Action.UP: Vector2i.UP,
	KeyUtils.Action.DOWN: Vector2i.DOWN,
	KeyUtils.Action.LEFT: Vector2i.LEFT,
	KeyUtils.Action.RIGHT: Vector2i.RIGHT
}
var selection: Array[Vector2i] = [Vector2i.ZERO, Vector2i.ZERO]
var selectors: Array[FlagsSelector] = []


func _ready() -> void:
	_place_flags()
	_place_selectors()
	EventBus.flag_selected.connect(_on_flag_selected.bind())


func _process(_delta: float) -> void:
	for i in range(selectors.size()):
		var selector := selectors[i]
		# 如果选择器已被选中，跳过处理
		if selector.is_selected:
			continue

		for action: KeyUtils.Action in move_dirs.keys():
			if KeyUtils.is_action_just_pressed(selector.control_scheme, action):
				_try_navigate(i, move_dirs[action])

	# 检查返回主菜单的条件
	if selectors[0].is_selected:
		return
	if not KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.PASS):
		return

	AudioPlayer.play(AudioPlayer.Sound.UI_NAV)
	transition_to_state(SoccerGame.ScreenType.MAIN_MENU)


func _place_flags() -> void:
	for j in range(NUM_ROWS):
		for i in range(NUM_COLS):
			var flag_texture := TextureRect.new()
			flag_texture.position = FLAG_ANCHOR_POINT + Vector2(55 * i, 40 * j)
			var country_index := 1 + i + j * NUM_COLS
			var country := DataLoader.get_countries()[country_index]
			flag_texture.texture = FlagHelper.get_flag_texture(country)
			flag_texture.scale = Vector2(1.5, 1.5)
			flag_texture.z_index = 1
			flags_container.add_child(flag_texture)


func _place_selectors() -> void:
	_add_selector(Player.ControlScheme.P1)

	if not GameManager.player_setup[1].is_empty():
		_add_selector(Player.ControlScheme.P2)


func _add_selector(control_scheme: Player.ControlScheme) -> void:
	var selector := FLAG_SELECTOR.instantiate()
	selector.position = flags_container.get_child(0).position
	selector.control_scheme = control_scheme
	flags_container.add_child(selector)
	selectors.append(selector)


func _try_navigate(selector_index: int, direction: Vector2i) -> void:
	# 检查选择器索引是否有效
	if selector_index < 0 or selector_index >= selectors.size():
		return

	var rect: Rect2i = Rect2i(0, 0, NUM_COLS, NUM_ROWS)
	var new_position := selection[selector_index] + direction

	# 如果新位置在有效范围内，直接移动
	if rect.has_point(new_position):
		selection[selector_index] = new_position
		var flag_index := selection[selector_index].x + selection[selector_index].y * NUM_COLS
		GameManager.player_setup[selector_index] = DataLoader.get_countries()[1 + flag_index]
		selectors[selector_index].position = flags_container.get_child(flag_index).position
		AudioPlayer.play(AudioPlayer.Sound.UI_NAV)
		return

	# 只处理垂直方向的边界循环
	if direction.x != 0:
		return

	# 处理垂直边界循环
	if direction.y == -1:
		_try_navigate(selector_index - NUM_COLS, direction)
	elif direction.y == 1:
		_try_navigate(selector_index + NUM_COLS, direction)


func _on_flag_selected() -> void:
	for selector in selectors:
		if not selector.is_selected:
			return

	var country_p1 := GameManager.player_setup[0]
	var country_p2 := GameManager.player_setup[1]

	if not country_p2.is_empty() and country_p1 != country_p2:
		GameManager.countries = [country_p1, country_p2]
		transition_to_state(SoccerGame.ScreenType.IN_GAME)