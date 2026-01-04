class_name FoodAttractionSystem
extends Node

var inventory := Inventory
var ingredient_catalog := IngredientCatalog

var cats: Array[CatInstance] = []
var bowls: Array[FoodBowlState] = []

var rng := RandomNumberGenerator.new()

func process_time(now: float) -> void:
	for bowl in bowls:
		if not bowl.is_active():
			continue
	
		var picked_cat := _pick_cat(bowl, now)
		if picked_cat:
			_schedule_cat(picked_cat, bowl, now)
		
	for cat in cats:
		if cat.is_busy and now >= cat.next_available_time:
			_resolve_arrival(cat, cat.target_bowl, now)

func _pick_cat(bowl: FoodBowlState, now: float) -> CatInstance:
	var eligible := cats.filter(func(c): return c.can_respond_to_bowl(bowl, now))
	if eligible.is_empty():
		return null
	return eligible.pick_random()

func _schedule_cat(cat: CatInstance, bowl: FoodBowlState, now: float) -> void:
	cat.is_busy = true
	cat.next_available_time = now + cat.data.base_travel_time
	cat.target_bowl = bowl
	bowl.has_cat_assigned = true

func _resolve_arrival(cat: CatInstance, bowl: FoodBowlState, now: float) -> void:
	var context := {
		"cat": cat,
		"cat_data": cat.data,
		"food_type": bowl.food_type,
		"bowl": bowl,
		"time": now,
		"inventory": inventory
	}
	
	cat.is_busy = false
	bowl.has_cat_assigned = false
	
	var ingredient := ingredient_catalog.roll_ingredient(context, rng)
	print("FoodAttractionSystem: <%s> trouxe o item <%s>" % [cat.data.name, ingredient.display_name])
	inventory.add_base_item(ingredient)
	
	var food_cost := int(1 * cat.data.food_efficiency)
	bowl.remaining_amount -= food_cost
	if bowl.remaining_amount <= 0:
		var bowl_index = bowls.find(bowl)
		SignalBus.bowl_state_changed.emit(bowl_index)
