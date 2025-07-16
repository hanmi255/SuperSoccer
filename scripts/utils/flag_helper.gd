class_name FlagHelper

static var flag_textures: Dictionary[String, Texture2D] = {}

static func get_flag_texture(country: String) -> Texture2D:
	if not flag_textures.has(country):
		flag_textures[country] = load("res://assets/sprites/ui/flags/flag-" + country.to_lower() + ".png")
	return flag_textures[country]
