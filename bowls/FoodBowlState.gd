# Determina o estado de cada tigela de ração
class_name FoodBowlState
extends Resource

@export var id: int = 0
@export var food_type: String
@export var remaining_amount: int
@export var has_cat_assigned: bool = false

func is_available() -> bool:
	return remaining_amount > 0 and not has_cat_assigned

# --------------- Transform data to save and load

func serialize() -> Dictionary:
	return {
		'id': id,
		'food_type': food_type,
		'remaining_amount': remaining_amount,
		'has_cat_assigned': has_cat_assigned
	}

func create_from_dict(data: Dictionary) -> void:
	id = data.id
	food_type = data.food_type
	remaining_amount = data.remaining_amount
	has_cat_assigned = data.has_cat_assigned
