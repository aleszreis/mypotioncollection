extends Node

const MAX_BOWLS := 5
var bowls: Dictionary = {}
var active_bowl_id: int = -1

func _ready():
	bowls = UserConfig.set_bowls_from_save()
	
	SignalBus.set_active_bowl.connect(_set_active_bowl)
	SignalBus.change_bowl_food.connect(_change_bowl_food)

func _unlock_bowl() -> void:
	if bowls.size() >= MAX_BOWLS:
		return
	
	var bowl := FoodBowlState.new()
	var new_index = bowls.values()[-1] + 1
	bowl.id = new_index
	bowls[new_index] = bowl

func _set_active_bowl(bowl_id):
	active_bowl_id = bowl_id
	
# ------------ Getters

func get_bowls() -> Array:
	return bowls.values()


func get_bowl_count():
	return len(bowls)

# ------------ Change Bowls state

func _change_bowl_food(food: FoodType):
	var bowl = bowls[active_bowl_id]
	bowl.food_type = food.id
	bowl.remaining_amount = food.fill_value
	
	SignalBus.update_bowl_button.emit()
	active_bowl_id = -1
	
	UserConfig.save_bowls(bowls)

func remove_food_from_bowl(amount: int, bowl: FoodBowlState):
	bowl.remaining_amount -= amount
	print("FoodAttractionSystem.bg: Bowl has <%s> of food left" % bowl.remaining_amount)
	
	if bowl.remaining_amount <= 0:
		bowl.food_type = ""
		SignalBus.update_bowl_button.emit()
