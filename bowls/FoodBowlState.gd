# Determina o estado de cada tigela de ração
class_name FoodBowlState
extends Resource

@export var food_type: FoodType
@export var remaining_amount: int
@export var cat_assigned: CatInstance = null

func is_available() -> bool:
	return remaining_amount > 0 and (cat_assigned == null)

func serialize() -> Dictionary:
	return {
		'food_type': food_type.serialize(),
		'remaining_amount': remaining_amount,
		'cat_assigned': cat_assigned.serialize()
	}
