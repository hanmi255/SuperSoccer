class_name GameStateData

var country_scored_for: String


static func build() -> GameStateData:
	return GameStateData.new()


func set_country_scored_for(country: String) -> GameStateData:
	country_scored_for = country
	return self