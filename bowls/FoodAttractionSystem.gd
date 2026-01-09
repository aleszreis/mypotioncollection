class_name FoodAttractionSystem
extends Node

var cats: Array[CatInstance] = []

var rng := RandomNumberGenerator.new()

func process_time(now: float) -> void:
	for bowl in FoodBowlManager.bowls:
		if not bowl.is_available():
			var cat = bowl.cat_assigned
			if cat and now >= cat.next_available_time:
				_resolve_arrival(cat, bowl, now)
			continue
			
		var picked_cat := _pick_cat(bowl, now)
		if picked_cat:
			_schedule_cat(picked_cat, bowl, now)
	UserConfig.save_bowls(FoodBowlManager.bowls)

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

func _schedule_cat(cat: CatInstance, bowl: FoodBowlState, now: float, chosen_item: String = "") -> void:
	var context := {
		"cat": cat,
		"cat_data": cat.cat_data,
		"food_type": bowl.food_type,
		"bowl": bowl,
		"time": now,
	}
	
	chosen_item = chosen_item if chosen_item else IngredientCatalog.roll_ingredient(context, rng)
	
	cat.set_exploration(now, chosen_item)
	bowl.cat_assigned = cat
	SignalBus.cat_scheduled.emit()
	
	print("FoodAttractionSystem.gd: <%s> agendado com item <%s>" % [context.cat_data.display_name, IngDatabase.get_by_id(cat.chosen_item).display_name])

func _resolve_arrival(cat: CatInstance, bowl: FoodBowlState, now: float) -> void:
	print("FoodAttractionSystem.gd: <%s> chegou." % cat.cat_data.display_name)
	SignalBus.ingredient_acquired.emit(cat.chosen_item)
	
	cat.set_idle()
	bowl.cat_assigned = null
	
	#print("FoodAttractionSystem.bg: Bowl has <%s> of food left" % bowl.remaining_amount)
	FoodBowlManager.remove_food_from_bowl(cat.cat_data.food_efficiency, bowl)
	
