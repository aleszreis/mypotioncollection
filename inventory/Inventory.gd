extends Node

var ingredients: Dictionary = {}
var potions: Dictionary = {}

func add_base_item(item: IngredientData) -> void:
	if not ingredients.get(item.id):
		ingredients[item.id] = {"data": item, "count": 1}
	else:
		ingredients[item.id]['count'] += 1
	
	UserConfig.save_inventory()
	SignalBus.changed_item.emit(item)

func add_created_item(item: PotionData) -> void:
	if potions.has(item):
		return
	potions[item.id] = item
	UserConfig.save_inventory()

func get_item_count(item: IngredientData):
	return ingredients[item.id]['count'] if ingredients.get(item.id) else 0
	
func remove_items(items: Array[IngredientData]):
	for item in items:
		if get_item_count(item) > 1:
			ingredients[item.id]['count'] -= 1
		else:
			ingredients.erase(item.id)
		SignalBus.changed_item.emit(item)

func _serialize_ingredients() -> Dictionary:
	var s_ing = {}
	for i in ingredients.values():
		s_ing[i.data.id] = {"data": i.data.serialize(), "count": i.count}
	return s_ing

func _serialize_potions() -> Dictionary:
	var s_pot = {}
	for p in potions.values():
		s_pot[p.id] = p.serialize()
	return s_pot

func deserialize_ingredients(ings: Dictionary) -> void:
	for item in ings.values():
		var ing_data = item.data
		var item_data = IngredientData.new()
		item_data.id = ing_data.id
		item_data.display_name = ing_data.display_name
		item_data.icon = ing_data.icon
		item_data.item_type = ing_data.item_type
		item_data.rarity = ing_data.rarity
		item_data.preffix = ing_data.preffix
		item_data.suffix = ing_data.suffix
		item_data.adj = ing_data.adj
		item_data.color = ing_data.color
		ingredients[ing_data.id] = {"data": item_data, "count": item.count}

func deserialize_potions(pots: Dictionary) -> void:
	for item in pots.values():
		var item_data = PotionData.new()
		item_data.id = item.id
		item_data.signature = item.signature
		item_data.display_name = item.display_name
		item_data.icon = item.icon
		item_data.rarity = item.rarity
		item_data.description = item.description
		item_data.discovered_at = item.discovered_at
		potions[item.id] = item_data
