extends Node

var file_path = "res://save.cfg" # "user://save.cfg"
var config := ConfigFile.new()
var _saving = false

func _ready():
	config.load(file_path)

func save_to_file():
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
	
func save_owned_cats():
	pass
	
	
func save_foods():
	pass
	
func save_bowls(bowls: Array[FoodBowlState]):
	config.set_value('bowls', 'bowls_list', bowls)
	
func save_registry(data: Dictionary):
	config.set_value('creation', 'registry', data)
	
func set_inventory_from_save():
	Inventory.ingredients = config.get_value('inventory', 'ingredients', {})
	Inventory.potions = config.get_value('inventory', 'potions', {})
	
func set_owned_cats_from_save():
	pass
	
func set_foods_from_save():
	pass
	
func set_bowls_from_save():
	var default_value: Array[FoodBowlState] = [FoodBowlState.new()]
	return config.get_value('bowls', 'bowls_list', default_value)

func set_registry_from_save():
	return config.get_value('creation', 'registry', {})
