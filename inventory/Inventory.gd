extends Node

var ingredients: Dictionary = {}
var potions: Dictionary = {}

func add_base_item(item: IngredientData) -> void:
	if not ingredients.get(item.id):
		ingredients[item.id] = {"data": item, "count": 1}
	else:
		ingredients[item.id]['count'] += 1
	
	SignalBus.changed_item.emit(item)

func add_created_item(item: PotionData) -> void:
	if potions.has(item):
		return
	potions[item.id] = item

func get_item_count(item: IngredientData):
	return ingredients[item.id]['count'] if ingredients.get(item.id) else 0
	
func remove_items(items: Array[IngredientData]):
	for item in items:
		if get_item_count(item) > 1:
			ingredients[item.id]['count'] -= 1
		else:
			ingredients.erase(item.id)
		SignalBus.changed_item.emit(item)
