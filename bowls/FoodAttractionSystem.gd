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
			UserConfig.save_bowls(bowls)

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
		"cat_data": cat.cat_id,
		"food_type": bowl.food_type,
		"bowl": bowl,
		"time": now,
	}
	
	cat.is_busy = true
	cat.next_available_time = now + Db.get_cat(cat.cat_id).base_travel_time
	cat.chosen_item = chosen_item if chosen_item else ingredient_catalog.roll_ingredient(context, rng)
	bowl.cat_assigned = cat
	
	# TODO: Atualizar bowls antes de salvar
	UserConfig.save_bowls(bowls)

	print("FoodAttractionSystem.gd: <%s> agendado com item <%s>" % [Db.get_cat(cat.cat_id).display_name, Db.get_ing(cat.chosen_item).display_name])

func _resolve_arrival(cat: CatInstance, bowl: FoodBowlState, now: float) -> void:
	print("FoodAttractionSystem.gd: <%s> chegou." % Db.get_cat(cat.cat_id).display_name)
	Inventory.add_base_item(cat.chosen_item)
	
	cat.is_busy = false
	cat.chosen_item = ""
	bowl.cat_assigned = null
	
	var new_food_value := bowl.remaining_amount - int(1 * Db.get_cat(cat.cat_id).food_efficiency)
	SignalBus.update_bowl.emit(bowl.food_type, new_food_value, bowls.find(bowl))
