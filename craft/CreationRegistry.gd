extends Node

var _registry: Dictionary = {}
var _generator := ProceduralItemGenerator.new()
var _name_generator := PotionNameGenerator.new()

func _ready():
	_registry = UserConfig.set_registry_from_save()

func get_or_create(signature: String, ingredients: Array[IngredientData]) -> PotionData:
	if _registry.has(signature):
		return _registry[signature]
	
	var potion_name = _name_generator._generate_name(ingredients)
	var item := _generator.generate_item(signature, potion_name, ingredients)
	_registry[signature] = item
	UserConfig.save_registry(_registry)
	return item

func potion_is_known(signature: String) -> PotionData:
	return _registry.get(signature)
