extends Node

var _registry: Dictionary = {}
var _generator := ProceduralItemGenerator.new()

func get_or_create(signature: String) -> PotionData:
	if _registry.has(signature):
		return _registry[signature]
	
	var item := _generator.generate_item(signature)
	_registry[signature] = item
	return item
