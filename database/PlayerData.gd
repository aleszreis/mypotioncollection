extends Node

var ingredient_data: Dictionary = {}
var potion_data: Dictionary = {}

func _ready():
	SignalBus.ingredient_acquired.connect(_update_ingredient_acquired)
	SignalBus.ingredient_consumed.connect(_update_ingredient_consumed)
	SignalBus.potion_acquired.connect(_update_potion_crafted)
	
	ingredient_data = UserConfig.set_player_ingr_data_from_save()
	potion_data = UserConfig.set_player_pot_data_from_save()

func _update_ingredient_acquired(ing_id: String) -> void:
	if ingredient_data.get(ing_id):
		ingredient_data[ing_id].acquired += 1
	else:
		ingredient_data[ing_id] = {
			"acquired": 1,
			"used_to_craft": 0,
			"used_as_currency": 0,
		}
		
	_save_player_info()

func _update_ingredient_consumed(ing_id: String, value: int, use: String) -> void:
	ingredient_data[ing_id][use] -= value
	
	_save_player_info()

func _update_potion_crafted(potion: PotionData) -> void:
	var pot_id = potion.signature
	if potion_data.get(pot_id):
		potion_data[pot_id].acquired += 1
	else:
		potion_data[pot_id] = {
			"acquired": 1,
			"discovered_at": str(Time.get_unix_time_from_system()),
		}
	
	_save_player_info()

func _save_player_info() -> void:
	UserConfig.save_player_data(ingredient_data, potion_data)
