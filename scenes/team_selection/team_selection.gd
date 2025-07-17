class_name TeamSelection
extends Control

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


func _process(_delta: float) -> void:
	for i in range(selectors.size()):
		var selector := selectors[i]
		if not selector.is_selected:
			for action: KeyUtils.Action in move_dirs.keys():
				if KeyUtils.is_action_just_pressed(selector.control_scheme, action):
					_try_navigate(i,move_dirs[action])


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
	if selector_index < 0 or selector_index >= selectors.size():
		return

	var rect: Rect2i = Rect2i(0, 0, NUM_COLS, NUM_ROWS)
	if rect.has_point(selection[selector_index] + direction):
		selection[selector_index] += direction
		var flag_index := selection[selector_index].x + selection[selector_index].y * NUM_COLS
		selectors[selector_index].position = flags_container.get_child(flag_index).position
		AudioPlayer.play(AudioPlayer.Sound.UI_NAV)
	else:
		if direction.x == 0:
			if direction.y == -1:
				_try_navigate(selector_index - NUM_COLS, direction)
			elif direction.y == 1:
				_try_navigate(selector_index + NUM_COLS, direction)
