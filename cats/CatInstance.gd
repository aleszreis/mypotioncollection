# Seleção do gato pra ir buscar um ingrediente
class_name CatInstance
extends Resource

@export var data: CatData

var is_busy := false
var next_available_time := 0.0
var target_bowl = FoodBowlState

func can_respond_to_bowl(bowl: FoodBowlState, now: float) -> bool:
	if is_busy:
		return false
	if now < next_available_time:
		return false
	if not data.accepted_foods.has(bowl.food_type.id):
		return false
	return true
