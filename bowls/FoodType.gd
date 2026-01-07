# Determina as comidas que serão usadas nas tigelas
class_name FoodType
extends Resource

@export var id: String
@export var display_name: String
@export var icon: Texture2D
@export var fill_value: int
@export var is_available: bool

func create_from_dict(data) -> void:
	id = data.id
	display_name = data.display_name
	icon = data.icon
	fill_value = data.fill_value
	is_available = data.is_available
