# Determina as comidas que serão usadas nas tigelas
class_name FoodType
extends Resource

@export var id: String
@export var display_name: String
@export var icon: Texture2D
@export var fill_value: int

func serialize() -> Dictionary:
	return {
		'id': id,
		'display_name': display_name,
		'icon': icon,
		'fill_value': fill_value,
	}
