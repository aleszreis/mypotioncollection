extends Node

var ingredients: Dictionary = {}
var potions: Dictionary = {}

func add_base_item(item: IngredientData) -> void:
	if not ingredients.get(item.id):
		ingredients[item.id] = {"data": item, "count": 1}
	else:
		ingredients[item.id]['count'] += 1
		
	SignalBus.item_acquired.emit(item)
	print(item.display_name + " adicionado ao inventário")

func add_created_item(item: PotionData) -> void:
	if potions.has(item):
		return
	potions[item.id] = item

func get_item_count(item: IngredientData):
	return ingredients[item.id]['count']
