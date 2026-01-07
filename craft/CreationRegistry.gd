extends Node

var _registry: Dictionary = {}  # Signature (String): { Data } (PotionData)
var _generator := ProceduralItemGenerator.new()
var _name_generator := PotionNameGenerator.new()

func _ready():
	_registry = UserConfig.set_potion_data_from_save()

func get_or_create(signature: String, ingredient_ids: Array[String]) -> PotionData:
	if _registry.has(signature):
		return _registry[signature]
	
	var ingredients: Array[IngredientData]
	for id in ingredient_ids:
		ingredients.append(IngDatabase.get_by_id(id))
	var potion_name = _name_generator.generate_name(ingredients)
	var item := _generator.generate_item(signature, potion_name, ingredients)
	_registry[signature] = item
	
	UserConfig.save_potions(_registry)
	
	return item

func potion_is_known(signature: String) -> PotionData:
	if _registry.has(signature):
		return _registry[signature]
	return null
	
func get_registry_data():
	return _registry
