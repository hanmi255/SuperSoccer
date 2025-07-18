class_name MainMenu
extends ScreenStateBase

const MENU_TEXTURES := [
	[preload("res://assets/sprites/ui/main_menu/1-player.png"), preload("res://assets/sprites/ui/main_menu/1-player-selected.png")],
	[preload("res://assets/sprites/ui/main_menu/2-players.png"), preload("res://assets/sprites/ui/main_menu/2-players-selected.png")]
]

@onready var selectable_textures: Array[TextureRect] = [%SinglePlayerTexture, %TwoPlayerTexture]
@onready var selection_icon: TextureRect = %SelectionIcon

var current_selection := 0
var is_active := false


func _ready() -> void:
	_refresh_ui()


func _process(_delta: float) -> void:
	if not is_active:
		return

	if KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.UP):
		_change_selection(current_selection - 1)
	elif KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.DOWN):
		_change_selection(current_selection + 1)
	elif KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.SHOOT):
		_submit_selection()


func _refresh_ui() -> void:
	for i in range(selectable_textures.size()):
		if current_selection == i:
			selectable_textures[i].texture = MENU_TEXTURES[i][1]
			selection_icon.position = selectable_textures[i].position + Vector2.LEFT * 25
		else:
			selectable_textures[i].texture = MENU_TEXTURES[i][0]


func _change_selection(new_selection: int) -> void:
	current_selection = clamp(new_selection, 0, selectable_textures.size() - 1)
	AudioPlayer.play(AudioPlayer.Sound.UI_NAV)
	_refresh_ui()


func _submit_selection() -> void:
	AudioPlayer.play(AudioPlayer.Sound.UI_SELECT)
	var country_default := DataLoader.get_countries()[1]
	var player_two := "" if current_selection == 0 else country_default
	GameManager.player_setup = [country_default, player_two]
	transition_to_state(SoccerGame.ScreenType.TEAM_SELECTION)


func _on_set_active() -> void:
	_refresh_ui()
	is_active = true