class_name FoodAttractionSystem
extends Node

var ingredient_catalog := IngredientCatalog

var cats: Array[CatInstance] = []
var bowls: Array[FoodBowlState] = []

var rng := RandomNumberGenerator.new()

func process_time(now: float) -> void:
	for bowl in bowls:
		if not bowl.is_available():
			var cat = bowl.cat_assigned
			if cat and now >= cat.next_available_time:
				_resolve_arrival(cat, bowl, now)
			continue
			
		var picked_cat := _pick_cat(bowl, now)
		if picked_cat:
			_schedule_cat(picked_cat, bowl, now)

func _pick_cat(bowl: FoodBowlState, now: float) -> CatInstance:
	var eligible := cats.filter(func(c): return c.can_respond_to_bowl(bowl, now))
	if eligible.is_empty():
		return null
	return eligible.pick_random()

func _schedule_cat(cat: CatInstance, bowl: FoodBowlState, now: float) -> void:
	cat.is_busy = true
	cat.next_available_time = now + cat.data.base_travel_time
	bowl.cat_assigned = cat

func _resolve_arrival(cat: CatInstance, bowl: FoodBowlState, now: float) -> void:
	var context := {
		"cat": cat,
		"cat_data": cat.data,
		"food_type": bowl.food_type,
		"bowl": bowl,
		"time": now,
	}
	
	var ingredient := ingredient_catalog.roll_ingredient(context, rng)
	print("FoodAttractionSystem: <%s> trouxe o item <%s>" % [cat.data.display_name, ingredient.display_name])
	Inventory.add_base_item(ingredient)
	
	cat.is_busy = false
	bowl.cat_assigned = null
	
	var new_food_value := bowl.remaining_amount - int(1 * cat.data.food_efficiency)
	SignalBus.update_bowl.emit(bowl.food_type, new_food_value, bowls.find(bowl))
	
	UserConfig.save_to_file()
