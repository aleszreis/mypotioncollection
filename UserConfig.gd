extends Node

var file_path = "res://save.cfg" # "user://save.cfg"
var config := ConfigFile.new()

func _ready():
	config.load(file_path)
	
	# Set cats
	
	# Set foods
	
	# Set bowls

func _save_info():
	var err = config.save(file_path)
	if err != OK:
		push_error("Erro ao salvar config: %s" % err)
	
func save_inventory(inventory: Inventory):
	config.set_value("inventory", "ingredients", inventory.ingredients)
	config.set_value("inventory", "potions", inventory.potions)
	
	_save_info()
	print("UserConfig.gd: inventário salvo")
	
func save_owned_cats():
	pass
	
func save_instanced_cats():
	pass
	
func save_foods():
	pass
	
func save_bowls(bowls: Array[FoodBowlState]):
	config.set_value("bowls", "bowls_list", bowls)
	
	_save_info()
	print("UserConfig.gd: tigelas salvas")

func save_registry(data: Dictionary):
	config.set_value('creation', 'registry', data)
	
	_save_info()
	print("UserConfig.gd: registro salvo")
	
func set_inventory_from_save():
	Inventory.ingredients = config.get_value('inventory', 'ingredients', {})
	Inventory.potions = config.get_value('inventory', 'potions', {})
	
func set_owned_cats_from_save():
	pass
	
func set_instanced_cats_from_save():
	pass
	
func set_foods_from_save():
	pass
	
func set_bowls_from_save():
	var default_value: Array[FoodBowlState] = [FoodBowlState.new()]
	return config.get_value('bowls', 'bowls_list', default_value)

func set_registry_from_save():
	return config.get_value('creation', 'registry', {})
