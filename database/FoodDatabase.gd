extends Database

@export var foods_data: Dictionary = {}

var FOODS_FILE_NAME = "racoes.json"

func _ready():
	_format_food_data()
	
func _format_food_data():
	var food_data_as_json = _parse_to_json(FOODS_FILE_NAME)
	
	# Format FoodType
	for data in food_data_as_json.values():
		data.icon = load("res://bowls/sprites/%s.png" % data.id)
		
		var food_data = FoodType.new()
		food_data.create_from_dict(data)
		foods_data[data.id] = food_data

func get_by_id(food_id: String) -> FoodType:
	return foods_data[food_id]
