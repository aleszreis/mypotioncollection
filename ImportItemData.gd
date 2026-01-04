extends Node

@export var ingredients_data: Dictionary = {}
@export var catalog_data: Array[IngredientEntry] = []
@export var cats_data: Dictionary = {}
@export var foods_data: Dictionary = {}

@export var MOCK_ITEM_DATA_LIST: Array[IngredientData]

var FOLDER_PATH = "res://z_json_files_to_import/Godot Item Data - "
var ITEMS_FILE_NAME = "ingredientes.json"
var CATS_FILE_NAME = "gatos.json"
var FOODS_FILE_NAME = "racoes.json"

func _ready():
	_format_items_data()
	_format_cats_data()
	_format_food_data()
	
func _parse_to_json(file_name):
	var file = FileAccess.open(FOLDER_PATH + file_name, FileAccess.READ)
	var data_as_text = file.get_as_text()
	file.close()
	return JSON.parse_string(data_as_text)

func _format_items_data():
	var ingredients_data_as_json = _parse_to_json(ITEMS_FILE_NAME)
	
	for item in ingredients_data_as_json.values():
		var item_data = IngredientData.new()
		item_data.id = str(item.id)
		item_data.display_name = item.display_name
		item_data.icon = load("res://ingredientes/sprites/%s.png" % item.icon_name)
		item_data.item_type = ItemTypes.Ingredient[item.item_type.to_upper()]
		item_data.rarity = item.rarity
		ingredients_data[item.id] = item_data

		var entry = IngredientEntry.new()
		entry.ingredient = item_data
		entry.base_weight = item.base_weight
		entry.rules = _format_rules(item.rules)
		catalog_data.append(entry)

		
func _format_cats_data():
	var cats_data_as_json = _parse_to_json(CATS_FILE_NAME)
	
	# Format CatData
	for data in cats_data_as_json.values():
		var cat_data = CatData.new()
		cat_data.id = data.id
		cat_data.name = data.name
		cat_data.food_efficiency = data.food_efficiency
		cat_data.base_travel_time = data.base_travel_time
		cat_data.favorite_item_type = ItemTypes.Ingredient[data.favorite_item_type.to_upper()]
		cat_data.favorite_item_id = data.favorite_item_id
		cat_data.accepted_foods = _format_string_to_array(data.accepted_foods)
		cat_data.rules = _format_rules(data.rules)
		cats_data[data.id] = cat_data

func _format_food_data():
	var food_data_as_json = _parse_to_json(FOODS_FILE_NAME)
	
	# Format FoodType
	for data in food_data_as_json.values():
		var food_data = FoodType.new()
		food_data.id = data.id
		food_data.display_name = data.display_name
		food_data.fill_value = data.fill_value
		food_data.icon = load("res://tigelas/sprites/%s.svg" % data.icon_name)
		foods_data[data.id] = food_data

func _format_string_to_array(s: String) -> Array[String]:
	var a: Array[String] = []
	for part in s.split(","):
		a.append(part.strip_edges())
	return a

func _format_rules(rules_as_string: String) -> Array[IngredientRule]:
	var rules_arr = _format_string_to_array(rules_as_string)
	
	var rules_formatted: Array[IngredientRule] = []
	for i in rules_arr:
		match i:
			'diminishing_rule':
				rules_formatted.append(DiminishingRule.new())
			'fave_item_type_rule':
				rules_formatted.append(FaveItemTypeRule.new())
			'fave_item_id_rule':
				rules_formatted.append(FaveItemIdRule.new())
	return rules_formatted
