# Determina o estado de cada tigela de ração
class_name FoodBowlState
extends Resource

@export var id: int = 0
@export var food_type: String
@export var remaining_amount: int
@export var cat_assigned: CatInstance = null

func is_available() -> bool:
	return remaining_amount > 0 and (cat_assigned == null)

# --------------- Transform data to save and load

func serialize() -> Dictionary:
	return {
		'id': id,
		'food_type': food_type,
		'remaining_amount': remaining_amount,
		'cat_assigned': cat_assigned.serialize() if cat_assigned else null
	}

func create_from_dict(data: Dictionary) -> void:
	id = data.id
	food_type = data.food_type
	remaining_amount = data.remaining_amount
	cat_assigned = null
	if data.cat_assigned:
		var cat = CatInstance.new()
		cat = cat.create_from_dict(data.cat_assigned)
		cat_assigned = cat
