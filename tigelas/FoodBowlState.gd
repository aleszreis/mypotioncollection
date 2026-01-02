# Determina o estado de cada tigela de ração
class_name FoodBowlState
extends Resource

@export var food_type: FoodType
@export var remaining_amount: int
@export var has_cat_assigned: bool = false

func is_active() -> bool:
	return remaining_amount > 0 and (not has_cat_assigned)
