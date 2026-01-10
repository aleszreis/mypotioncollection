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

# ---------- CATS
func save_owned_cats():
	pass
	
func set_owned_cats_from_save():
	pass

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
func save_bowls(bowls: Array[FoodBowlState]):
	var serialized_bowls = bowls.map(func(b): return b.serialize())
	config.set_value('bowls', 'bowls_list', serialized_bowls)
	
	_save_to_file()

func set_bowls_from_save() -> Array[FoodBowlState]:
	var b: Array = config.get_value('bowls', 'bowls_list', [])
	if b.is_empty():
		return [FoodBowlState.new()]
	
	var result: Array[FoodBowlState]
	for bowl in b:
		var new_bowl = FoodBowlState.new()
		new_bowl.create_from_dict(bowl)
		result.append(new_bowl)
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
