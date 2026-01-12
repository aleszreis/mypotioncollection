extends Database

@export var cats_data: Dictionary = {}
@export var cats_instances: Array = []

var CATS_FILE_NAME = "gatos.json"

## TO BE EDITED LATER
var CAT_TRAVEL_TIME_MULTIPLIER = 5

func _ready():
	_format_cats_data()
	_format_cat_instances()

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
		cat_data.item_types = _format_item_types(data.item_types)
		if data.favorite_item_id:
			cat_data.favorite_item_id = data.favorite_item_id
		cat_data.accepted_foods = _format_string_to_array(data.accepted_foods)
		cat_data.accepted_foods = _format_foods(cat_data.accepted_foods)
		cat_data.rules = _format_rules(data.rules)
		cats_data[data.id] = cat_data

func _format_item_types(items: String) -> Array[int]:
		var items_as_string = _format_string_to_array(items)
		var result: Array[int] = []
		for item in items_as_string:
			result.append(int(item))
		return result

func _format_foods(foods_list: Array[String]) -> Array:
	var translation = {
		"common": "food_1",
		"flower": "food_2",
		"fruit": "food_3",
		"spice": "food_4",
		"gem": "food_5",
		"premium": "food_6",
		"special": "food_7",
	}
	var result: Array[String] = []
	for food in foods_list:
		result.append(translation[food])
	
	return result

func _format_cat_instances():
	for cat_id in cats_data:
		var cat_instance := CatInstance.new()
		cat_instance.cat_data = CatDatabase.get_by_id(cat_id)
		cats_instances.append(cat_instance)

func get_by_id(cat_id: String) -> CatData:
	return cats_data[cat_id]
