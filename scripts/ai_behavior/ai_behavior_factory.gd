class_name AIBehaviorFactory

var roles: Dictionary


func _init() -> void:
	roles = {
		Player.Role.GOALIE: AIBehaviorGoalie,
		Player.Role.DEFENDER: AIBehaviorField,
		Player.Role.MIDFIELDER: AIBehaviorField,
		Player.Role.FORWARD: AIBehaviorField,
	}


func get_ai_behavior(role: Player.Role) -> AIBehaviorBase:
	assert(roles.has(role), "Invalid role: %s" % role)
	return roles.get(role).new()
