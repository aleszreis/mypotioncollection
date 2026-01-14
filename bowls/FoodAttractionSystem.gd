class_name FoodAttractionSystem
extends Node

var cats: Array[CatInstance] = []

var rng := RandomNumberGenerator.new()

func process_time(now: float) -> void:
	var traveling_cats = cats.filter(func(c): return c.is_busy)
	for cat: CatInstance in traveling_cats:
		if cat.next_available_time <= now:
			_resolve_arrival(cat, now)
		continue
	for bowl in FoodBowlManager.get_bowls():
		if not bowl.is_available():
			continue
			
		var picked_cat := _pick_cat(bowl, now)
		if picked_cat:
			var item = _pick_item(picked_cat)
			_schedule_cat(picked_cat, item, now, bowl)

func _pick_cat(bowl: FoodBowlState, now: float) -> CatInstance:
	var eligible := cats.filter(func(c): return c.can_respond_to_bowl(bowl, now))
	if eligible.is_empty():
		return null
		
	var total_weight := 0.0
	for c in eligible:
		total_weight += c.base_weight

	var roll := randf() * total_weight
	var acc := 0.0

	for c in eligible:
		acc += c.base_weight
		if roll <= acc:
			return c

	return eligible.back() # fallback de segurança

func _pick_item(cat, chosen_item: String = "") -> String:
	var context := {
		"cat": cat,
		"cat_data": cat.cat_data,
	}
	
	return chosen_item if chosen_item else IngredientCatalog.roll_ingredient(context, rng)

func _schedule_cat(cat: CatInstance, chosen_item: String, now: float, bowl: FoodBowlState = null) -> void:
	cat.set_exploration(now, chosen_item, bowl)
	bowl.has_cat_assigned = true
	
	print("FoodAttractionSystem.gd: <%s> agendado com item <%s>" % [cat.cat_data.display_name, IngDatabase.get_by_id(chosen_item).display_name])
	
	UserConfig.save_arrival_state(cats, FoodBowlManager.bowls)

func _resolve_arrival(cat: CatInstance, now: float) -> void:
	print("FoodAttractionSystem.gd: <%s> chegou." % cat.cat_data.display_name)
	SignalBus.ingredient_acquired.emit(cat.chosen_item)
	
	var bowl = FoodBowlManager.bowls.get(cat.target_bowl)
	if bowl:
		bowl.has_cat_assigned = false
		FoodBowlManager.remove_food_from_bowl(cat.cat_data.food_efficiency, bowl)
		
	cat.set_idle()
	UserConfig.save_arrival_state(cats, FoodBowlManager.bowls)
	
