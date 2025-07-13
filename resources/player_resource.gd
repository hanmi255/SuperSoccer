class_name PlayerResource
extends Resource

@export var full_name: String
@export var role: Player.Role
@export var skin_color: Player.SkinColor
@export var speed: float
@export var power: float


func _init(player_name: String, player_role: Player.Role, player_skin_color: Player.SkinColor, player_speed: float, player_power: float) -> void:
	full_name = player_name
	role = player_role
	skin_color = player_skin_color
	speed = player_speed
	power = player_power
