extends Node

@export var ingredients_data: Dictionary = {}
@export var cats_data: Dictionary = {}
@export var foods_data: Dictionary = {}

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
	var json = JSON.new()
	file.close()
	return json.parse_string(data_as_text)

func _format_items_data():
	ingredients_data = _parse_to_json(ITEMS_FILE_NAME)
	
	# Format ingredients data (IngredientCatalog will properly format as IngredientEntry and store IngredientData later)
	for item_id in ingredients_data.keys():
		ingredients_data[item_id]['id'] = str(item_id)
		ingredients_data[item_id]['icon'] = "res://ingredientes/sprites/" + ingredients_data[item_id]['display_name'] + ".png"
		ingredients_data[item_id]['rules'] = [] if ingredients_data[item_id]['rules'] == null else ingredients_data[item_id]['rules']

func _format_cats_data():
	var cats_data_as_json = _parse_to_json(CATS_FILE_NAME)
	
	# Format CatData
	for data in cats_data_as_json.values():
		var cat_data = CatData.new()
		cat_data.id = data.id
		cat_data.name = data.name
		cat_data.food_efficiency = data['food efficiency']
		cat_data.base_travel_time = data['base travel time']
		for part in data['accepted foods'].split(","):
			cat_data.accepted_foods.append(part.strip_edges())
		cats_data[data.id] = cat_data

func _format_food_data():
	var food_data_as_json = _parse_to_json(FOODS_FILE_NAME)
	
	# Format FoodType
	for data in food_data_as_json.values():
		var food_data = FoodType.new()
		food_data.id = data.id
		food_data.display_name = data['display name']
		food_data.fill_value = data['fill value']
		foods_data[data.id] = food_data
