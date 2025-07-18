class_name FlagsSelector
extends Control

@onready var indicator_p1: TextureRect = $IndicatorP1
@onready var indicator_p2: TextureRect = $IndicatorP2
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var control_scheme := Player.ControlScheme.P1
var is_selected := false


func _ready() -> void:
	indicator_p1.visible = control_scheme == Player.ControlScheme.P1
	indicator_p2.visible = control_scheme == Player.ControlScheme.P2


func _process(_delta) -> void:
	if not is_selected and KeyUtils.is_action_just_pressed(control_scheme, KeyUtils.Action.SHOOT):
		is_selected = true
		animation_player.play("selected")
		SoundPlayer.play(SoundPlayer.Sound.UI_SELECT)
		EventBus.flag_selected.emit()
	elif is_selected and KeyUtils.is_action_just_released(control_scheme, KeyUtils.Action.PASS):
		is_selected = false
		animation_player.play("selecting")
