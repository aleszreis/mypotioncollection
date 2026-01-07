class_name FoodBowlManager
extends Node

@onready var food_modal = $"../../FoodOptionsMenu"

const MAX_BOWLS := 5
var bowls: Array[FoodBowlState] = []
var active_bowl_index: int = -1

func _ready():
	bowls = UserConfig.set_bowls_from_save()
	#for b in bowls:
		#b.cat_assigned = null
	SignalBus.update_bowl.connect(_update_bowl)

func get_bowl_count():
	return len(bowls)

func add_bowl() -> bool:
	if bowls.size() >= MAX_BOWLS:
		return false
	
	var bowl := FoodBowlState.new()
	bowls.append(bowl)
	UserConfig.save_bowls(bowls)
	return true

func remove_bowl() -> void:
	if bowls.size() == 0:
		return
	
	bowls.pop_back()
	UserConfig.save_bowls(bowls)

func set_active_bowl(index):
	active_bowl_index = index

func _update_bowl(food_type: String, new_amount: int, idx: int = active_bowl_index):
	var curr_bowl = bowls[idx]
	curr_bowl.food_type = food_type
	curr_bowl.remaining_amount = new_amount
	
	if curr_bowl.remaining_amount <= 0:
		curr_bowl.food_type = ""
	
	UserConfig.save_bowls(bowls)
	SignalBus.update_bowl_button.emit(idx)
	active_bowl_index = -1
