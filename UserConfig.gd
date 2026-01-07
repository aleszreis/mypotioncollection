extends Node

var file_path = "res://save.cfg" # "user://save.cfg"
var config := ConfigFile.new()
var _saving = false

func _ready():
	config.load(file_path)

func _save_to_file():
	if _saving:
		return

	_saving = true
	await get_tree().process_frame

	var err = config.save(file_path)
	if err != OK:
		push_error("Erro ao salvar config: %s" % err)
		
	_saving = false

func save_inventory():
	config.set_value("inventory", "ingredients", Inventory.ingredients)
	config.set_value("inventory", "potions", Inventory.potions)
	
	_save_to_file()
	
func save_owned_cats():
	pass
	
func save_foods():
	pass
	
func save_bowls(bowls: Array[FoodBowlState]):
	var serialized_bowls = bowls.map(func(b): return b.serialize())
	config.set_value('bowls', 'bowls_list', serialized_bowls)
	
	_save_to_file()
	
func save_registry(potion_data: Dictionary, data: Dictionary):
	var serial_pot_data = {}
	for pot: PotionData in potion_data.values():
		serial_pot_data[pot.id] = pot.serialize()
		
	config.set_value('creation', 'registry', serial_pot_data)
	config.set_value('creation', 'signatures', data)
	
	_save_to_file()
	
func set_inventory_from_save():
	Inventory.ingredients = config.get_value('inventory', 'ingredients', {})
	Inventory.potions = config.get_value('inventory', 'potions', [])
	
func set_owned_cats_from_save():
	pass
	
func set_foods_from_save():
	pass
	
func set_bowls_from_save() -> Array[FoodBowlState]:
	var b: Array = config.get_value('bowls', 'bowls_list', [])
	
	var result: Array[FoodBowlState]
	for bowl in b:
		var new_bowl = FoodBowlState.new()
		new_bowl.create_from_dict(bowl)
		#var cat = null
		#if bowl.cat_assigned:
			#cat = CatInstance.new()
			#cat.base_weight = bowl.cat_assigned.base_weight
			#cat.cat_id = bowl.cat_assigned.cat_id
			#cat.chosen_item = bowl.cat_assigned.chosen_item
			#cat.is_busy = bowl.cat_assigned.is_busy
			#cat.next_available_time = bowl.cat_assigned.next_available_time
		#new_bowl.cat_assigned = cat
		#new_bowl.food_type = bowl.food_type
		#new_bowl.remaining_amount = bowl.remaining_amount
		result.append(new_bowl)
	return result

func set_potion_data_from_save():
	var serial_pot_data = config.get_value('creation', 'registry', {})
	var pot_as_data := {}
	for pot_data in serial_pot_data.values():
		var potion = PotionData.new()
		potion.create_from_dict(pot_data)
		pot_as_data[potion.id] = potion
	
	return pot_as_data

func set_registry_from_save():
	return config.get_value('creation', 'signatures', {})
