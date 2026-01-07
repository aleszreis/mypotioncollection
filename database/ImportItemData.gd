extends Node

@export var ingredients_data: Dictionary = {}
@export var potions_data: Dictionary = {}
@export var catalog_data: Array[IngredientEntry] = []
@export var cats_data: Dictionary = {}
@export var foods_data: Dictionary = {}

var FOLDER_PATH = "res://z_json_files_to_import/Godot Item Data - "
var ITEMS_FILE_NAME = "ingredientes.json"
var CATS_FILE_NAME = "gatos.json"
var FOODS_FILE_NAME = "racoes.json"

## TO BE EDITED LATER
var CAT_TRAVEL_TIME_MULTIPLIER = 1

func _ready():
	_format_items_data()
	_format_cats_data()
	_format_food_data()
	
	potions_data = UserConfig.set_potion_data_from_save()
	
func _parse_to_json(file_name):
	var file = FileAccess.open(FOLDER_PATH + file_name, FileAccess.READ)
	var data_as_text = file.get_as_text()
	file.close()
	return JSON.parse_string(data_as_text)

func _format_items_data():
	var ingredients_data_as_json = _parse_to_json(ITEMS_FILE_NAME)
	
	for item_data in ingredients_data_as_json.values():
		var item = IngredientData.new()
		item.create_from_dict(item_data)
		ingredients_data[item_data.id] = item

		var entry = IngredientEntry.new()
		entry.ingredient_id = item_data.id
		entry.base_weight = item_data.base_weight
		entry.rules = _format_rules(item_data.rules)
		catalog_data.append(entry)
	
func _format_cats_data():
	var cats_data_as_json = _parse_to_json(CATS_FILE_NAME)
	
	# Format CatData
	for data in cats_data_as_json.values():
		var cat_data = CatData.new()
		cat_data.id = data.id
		cat_data.display_name = data.display_name
		cat_data.food_efficiency = data.food_efficiency
		cat_data.rarity = data.rarity
		cat_data.base_travel_time = data.rarity * CAT_TRAVEL_TIME_MULTIPLIER
		cat_data.item_types = _format_string_to_array(data.item_types)
		if data.favorite_item_id:
			cat_data.favorite_item_id = data.favorite_item_id
		cat_data.accepted_foods = _format_string_to_array(data.accepted_foods)
		cat_data.rules = _format_rules(data.rules)
		cats_data[data.id] = cat_data

func _format_food_data():
	var food_data_as_json = _parse_to_json(FOODS_FILE_NAME)
	
	# Format FoodType
	for data in food_data_as_json.values():
		data.icon = load("res://bowls/sprites/%s.png" % data.id)
		
		var food_data = FoodType.new()
		food_data.create_from_dict(data)
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
			'extra_diminishing_rule':
				rules_formatted.append(ExtraDiminishingRule.new())
			'item_types':
				rules_formatted.append(ItemTypesRule.new())
			'fave_item_id_rule':
				rules_formatted.append(FaveItemIdRule.new())
	return rules_formatted

func get_ing(ing_id: String) -> IngredientData:
	return ingredients_data[ing_id]

func get_pot(pot_id: String) -> PotionData:
	return potions_data[pot_id]

func get_cat(cat_id: String) -> CatData:
	return cats_data[cat_id]

func get_food(food_id: String) -> FoodType:
	return foods_data[food_id]
