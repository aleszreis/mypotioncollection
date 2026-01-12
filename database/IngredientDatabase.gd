extends Database

@export var ingredients_data: Dictionary = {}
@export var catalog_data: Array[IngredientEntry] = []

var ITEMS_FILE_NAME = "ingredientes.json"

func _ready():
	_format_items_data()
	_format_entries_data()

func _format_items_data():
	var ingredients_data_as_json = _parse_to_json(ITEMS_FILE_NAME)
	
	for item_data in ingredients_data_as_json.values():
		var item = IngredientData.new()
		item.create_from_dict(item_data)
		ingredients_data[item_data.id] = item

func _format_entries_data():
	var ingredients_data_as_json = _parse_to_json(ITEMS_FILE_NAME)
	
	for item_data in ingredients_data_as_json.values():
		var entry = IngredientEntry.new()
		entry.ingredient = get_by_id(item_data.id)
		entry.base_weight = item_data.base_weight
		entry.rules = _format_rules(item_data.rules)
		catalog_data.append(entry)

func get_by_id(ing_id: String) -> IngredientData:
	return ingredients_data[ing_id]

func can_be_fetched(ing_id: String) -> void:
	ingredients_data[ing_id].can_be_fetched = true
