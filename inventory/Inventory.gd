extends Node

var ingredients: Dictionary = {}
var potions: Array = []

func _ready():
	UserConfig.set_inventory_from_save()
	
	SignalBus.ingredient_acquired.connect(_add_ingredient)
	SignalBus.potion_acquired.connect(_add_potion)

func _add_ingredient(item_id: String) -> void:
	if not ingredients.get(item_id):
		ingredients[item_id] = 1
	else:
		ingredients[item_id] += 1
	
	SignalBus.change_ui_ingredient.emit(item_id)
	UserConfig.save_inventory()

func _add_potion(potion: PotionData) -> void:
	var signature = potion.signature
	if potions.has(signature):
		return
	potions.append(signature)
	
	UserConfig.save_inventory()

func get_item_count(item_id: String):
	return ingredients[item_id] if ingredients.get(item_id) else 0
	
func remove_item(item_id: String):
	if get_item_count(item_id) > 1:
		ingredients[item_id] -= 1
	else:
		ingredients.erase(item_id)
	SignalBus.change_ui_ingredient.emit(item_id)
