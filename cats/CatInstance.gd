# Seleção do gato pra ir buscar um ingrediente
class_name CatInstance
extends Resource

@export var cat_data: CatData
@export var base_weight: float = 1.0

var is_busy := false
var next_available_time := 0.0
var chosen_item := ""

func _ready():
	base_weight = _rarity_to_weight(cat_data.rarity)

func can_respond_to_bowl(bowl: FoodBowlState, now: float) -> bool:
	if is_busy:
		return false
	if now < next_available_time:
		return false
	if not cat_data.accepted_foods.has(bowl.food_type):
		return false
	return true

func _rarity_to_weight(rarity: int) -> float:
	return 1.0 / rarity

func serialize() -> Dictionary:
	return {
		"cat_data": cat_data.id,
		"base_weight": base_weight,
		"is_busy": is_busy,
		"next_available_time": str(next_available_time),
		"chosen_item": chosen_item,
	}

func create_from_dict(data: Dictionary) -> CatInstance:
	var cat = CatInstance.new()
	cat.cat_data = CatDatabase.get_by_id(data.cat_data)
	cat.base_weight = data.base_weight
	cat.is_busy = data.is_busy
	cat.next_available_time = float(data.next_available_time)
	cat.chosen_item = data.chosen_item
	return cat
