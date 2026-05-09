# Informações de cada possível gato visitante
class_name CatData
extends Resource

@export var id: String
@export var icon: SpriteFrames
@export var walking_sprite: SpriteFrames
@export var display_name: String
@export var rarity: int

@export var accepted_foods: Array[String] # ID dos FoodTypes aceitos
@export var food_efficiency: float = 1.0
@export var base_travel_time: float = 2.0

@export var favorite_item_id: String
@export var item_types: Array[int]

@export var rules: Array[Rule] = []

func serialize() -> Dictionary:
	return {
		"id": id,
		"display_name": display_name,
		"rarity": rarity,
		"accepted_foods": accepted_foods.duplicate(),
		"food_efficiency": food_efficiency,
		"base_travel_time": base_travel_time,
		"favorite_item_id": favorite_item_id,
		"item_types": item_types.duplicate(),
		"rules": rules.map(func(r): return r.serialize())
		}

func create_from_dict(data: Dictionary) -> void:
	id = data.id
	display_name = data.display_name
	rarity = data.rarity
	accepted_foods = data.accepted_foods
	food_efficiency = data.food_efficiency
	base_travel_time = data.base_travel_time
	favorite_item_id = data.favorite_item_id
	item_types = data.item_types
	rules = data.rules
