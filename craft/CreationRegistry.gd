extends Node

var _registry: Dictionary = {}
var _generator := ProceduralItemGenerator.new()
var _name_generator := PotionNameGenerator.new()

func _ready():
	_registry = UserConfig.set_registry_from_save()

func get_or_create(signature: String, ingredients: Array[String]) -> String:
	if _registry.has(signature):
		return _registry[signature]
	
	var potion_name = _name_generator._generate_name(ingredients)
	var item_id := _generator.generate_item(signature, potion_name, ingredients)
	_registry[signature] = item_id
	UserConfig.save_registry(_registry)
	return item_id

func potion_is_known(signature: String) -> String:
	return _registry.get(signature, "")
	
func get_registry_data():
	return _registry
