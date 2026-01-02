class_name FoodBowlManager
extends Node

@onready var food_modal = $"../../FoodOptionsMenu"

const MAX_BOWLS := 5
var bowls: Array[FoodBowlState] = []
var active_bowl_index: int = -1

func get_bowl_count():
	return len(bowls)

func add_bowl() -> bool:
	if bowls.size() >= MAX_BOWLS:
		return false
	
	var bowl := FoodBowlState.new()
	bowls.append(bowl)
	print("FoodBowlManager: Tigela criada")
	return true

func set_active_bowl(index):
	active_bowl_index = index
	
func fill_bowl(food_type: FoodType):
	bowls[active_bowl_index].food_type = food_type
	bowls[active_bowl_index].remaining_amount = food_type.fill_value
	print("FoodBowlManager: Tigela %s preenchida com comida %s" % [active_bowl_index, food_type.display_name])
	active_bowl_index = -1
	food_modal.close()
