class_name ScreenStateFactory

var states: Dictionary


func _init() -> void:
	states = {
		SoccerGame.ScreenType.MAIN_MENU: preload("res://scenes/screens/main_menu/main_menu.tscn"),
		SoccerGame.ScreenType.TEAM_SELECTION: preload("res://scenes/screens/team_selection/team_selection.tscn"),
		SoccerGame.ScreenType.IN_GAME: preload("res://scenes/screens/world/world.tscn")
	}


func get_fresh_state(state: SoccerGame.ScreenType) -> ScreenStateBase:
	assert(states.has(state), "State not found: %s" % state)

	return states.get(state).instantiate()