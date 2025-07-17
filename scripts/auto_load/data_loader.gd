## 球队数据加载工具
## 负责从JSON文件加载球队和球员数据，并提供访问接口
extends Node

## 国家列表
var _countries: Array[String] = ["FRANCE"]
## 存储所有球队数据的字典，键为国家名称，值为该国家的球员数组
var _squads: Dictionary[String, Array]

## 初始化函数，在节点创建时自动调用
func _init() -> void:
	load_squads()

## 从JSON文件加载球队数据
## 解析squads.json文件，创建球员资源对象并存储到_squads字典中
func load_squads() -> void:
	var json_file: FileAccess = FileAccess.open("res://assets/json/squads.json", FileAccess.READ)
	if json_file == null:
		printerr("Failed to open squads.json")
		return

	var json_text: String = json_file.get_as_text()
	var json := JSON.new()
	if json.parse(json_text) != OK:
		printerr("Failed to parse squads.json: ", json.get_error_message())
		return

	# 遍历JSON中的每个球队
	for team in json.get_data():
		var country_name := team["country"] as String
		_countries.append(country_name)
		var players := team["players"] as Array

		if not _squads.has(country_name):
			_squads[country_name] = []

		# 遍历每个球队的球员列表
		for player in players:
			var player_name := player["name"] as String
			var player_role := player["role"] as Player.Role
			var player_skin_color := player["skin_color"] as Player.SkinColor
			var player_speed := player["speed"] as float
			var player_power := player["power"] as float

			# 创建球员资源对象并添加到对应国家的球员数组中
			var player_resource := PlayerResource.new(player_name, player_role, player_skin_color, player_speed, player_power)
			_squads[country_name].append(player_resource)

		# 确保每个球队有6名球员
		assert(players.size() == 6)

	json_file.close()


## 根据国家名称获取球员数组
## 参数:
##   country_name - 国家名称
## 返回:
##   包含该国家所有球员资源的数组，如果国家不存在则返回空数组
func get_squad(country_name: String) -> Array:
	if not _squads.has(country_name):
		printerr("Squad not found: ", country_name)
		return []

	return _squads[country_name]


## 获取国家列表
## 返回:
##   国家列表
func get_countries() -> Array[String]:
	return _countries