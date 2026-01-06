extends Node

var ingredients: Dictionary = {}
var potions: Array = []

func add_base_item(item_id: String) -> void:
	if not ingredients.get(item_id):
		ingredients[item_id] = 1
	else:
		ingredients[item_id] += 1
	
	UserConfig.save_inventory()
	SignalBus.changed_item.emit(item_id)

func add_created_potion(item_id: String) -> void:
	if potions.has(item_id):
		return
	potions.append(item_id)
	UserConfig.save_inventory()

func get_item_count(item_id: String):
	return ingredients[item_id] if ingredients.get(item_id) else 0
	
func remove_item(item_id: String):
	if get_item_count(item_id) > 1:
		ingredients[item_id] -= 1
	else:
		ingredients.erase(item_id)
	SignalBus.changed_item.emit(item_id)
