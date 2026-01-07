# Determina o estado de cada tigela de ração
class_name FoodBowlState
extends Resource

@export var food_type: String
@export var remaining_amount: int
@export var cat_assigned: CatInstance = null

func is_available() -> bool:
	return remaining_amount > 0 and (cat_assigned == null)

func serialize() -> Dictionary:
	return {
		'food_type': food_type,
		'remaining_amount': remaining_amount,
		# TODO: incluir lógica de processamento offline para determinar gato por bowl
		'cat_assigned': null
	}

func create_from_dict(data: Dictionary) -> void:
	food_type = data.food_type
	remaining_amount = data.remaining_amount
	# TODO: incluir lógica de processamento offline para determinar gato por bowl
	cat_assigned = null
