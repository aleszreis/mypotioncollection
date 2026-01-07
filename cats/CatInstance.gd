# Seleção do gato pra ir buscar um ingrediente
class_name CatInstance
extends Resource

@export var cat_id: String
@export var base_weight: float = 1.0

var is_busy := false
var next_available_time := 0.0
var chosen_item := ""

func _ready():
	base_weight = _rarity_to_weight(Db.get_cat(cat_id).rarity)

func can_respond_to_bowl(bowl: FoodBowlState, now: float) -> bool:
	if is_busy:
		return false
	if now < next_available_time:
		return false
	if not Db.get_cat(cat_id).accepted_foods.has(bowl.food_type):
		return false
	return true

func _rarity_to_weight(rarity: int) -> float:
	return 1.0 / rarity

func serialize() -> Dictionary:
	return {
		"cat_id": cat_id,
		"base_weight": base_weight,
		"is_busy": is_busy,
		"next_available_time": next_available_time,
		"chosen_item": chosen_item,
	}

func create_from_dict(data: Dictionary) -> void:
	cat_id = data.cat_id
	base_weight = data.base_weight
	is_busy = data.is_busy
	next_available_time = data.next_available_time
	chosen_item = data.chosen_item
