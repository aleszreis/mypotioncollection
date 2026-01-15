extends Node

var file_path = "user://save.cfg" # "user://save.cfg"
var config := ConfigFile.new()
var _saving = false

func _ready():
	config.load(file_path)

func _save_to_file():
	if _saving:
		return

	_saving = true
	await get_tree().process_frame
	config.set_value("metadata", "last_saved_at", str(Time.get_unix_time_from_system()))
	config.set_value("metadata", "last_saved_date", str(Time.get_datetime_string_from_system()))

	print("Saved data.")

	var err = config.save(file_path)
	if err != OK:
		push_error("Erro ao salvar config: %s" % err)
	
	_saving = false

# ---------- SAVE GAME STATE
func save_arrival_state(cats: Array[CatInstance], bowls: Dictionary) -> void:
	save_cats(cats)
	save_bowls(bowls)
	
	_save_to_file()
	
# ---------- CATS
func save_cats(cats: Array[CatInstance]):
	var serialized_cats = cats.map(func(c): return c.serialize())
	config.set_value('cats', 'all_cats', serialized_cats)
	
func set_cats_from_save() -> Array[CatInstance]:
	var c: Array = config.get_value('cats', 'all_cats', [])
	if c.is_empty():
		return []
	
	var result: Array[CatInstance]
	for cat in c:
		var new_cat = CatInstance.new()
		new_cat.create_from_dict(cat)
		result.append(new_cat)
	return result

# ---------- FOODS
func save_foods():
	pass

func set_foods_from_save():
	pass

# ---------- INVENTORY
func save_inventory():
	config.set_value("inventory", "ingredients", Inventory.ingredients)
	config.set_value("inventory", "potions", Inventory.potions)
	
	_save_to_file()
	
func set_inventory_from_save():
	Inventory.ingredients = config.get_value('inventory', 'ingredients', {})
	Inventory.potions = config.get_value('inventory', 'potions', [])

# ---------- BOWLS
func save_bowls(bowls: Dictionary):
	var serialized_bowls = bowls.values().map(func(b): return b.serialize())
	config.set_value('bowls', 'bowls_list', serialized_bowls)

func set_bowls_from_save() -> Dictionary:
	var b = config.get_value('bowls', 'bowls_list', [])
	if b.is_empty():
		return {0: FoodBowlState.new()}
	
	var result: Dictionary = {}
	for bowl_data in b:
		var new_bowl = FoodBowlState.new()
		new_bowl.create_from_dict(bowl_data)
		result[bowl_data.id] = new_bowl
	return result

# ---------- POTIONS
func save_potions(potion_data: Dictionary):
	var serial_pot_data = {}
	for pot: PotionData in potion_data.values():
		serial_pot_data[pot.signature] = pot.serialize()
		
	config.set_value('potions', 'registry', serial_pot_data)
	
	_save_to_file()
	
func set_potion_data_from_save():
	var serial_pot_data = config.get_value('potions', 'registry', {})
	var pot_as_data := {}
	for pot_data in serial_pot_data.values():
		var potion = PotionData.new()
		potion.create_from_dict(pot_data)
		pot_as_data[potion.signature] = potion
	
	return pot_as_data

# ---------- PLAYER DATA & ACHIEVEMENTS
func save_player_data(ingredient_data, potion_data) -> void:
	config.set_value('player', 'ingredient_data', ingredient_data)
	config.set_value('player', 'potion_data', potion_data)
	
	_save_to_file()
	
func set_player_ingr_data_from_save():
	return config.get_value('player', 'ingredient_data', {})

func set_player_pot_data_from_save():
	return config.get_value('player', 'potion_data', {})

# ---------- METADATA
func get_last_save_time() -> float:
	return float(config.get_value('metadata', 'last_saved_at', 0.0))
