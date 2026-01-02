class_name SelectionNormalizer
extends Node

static func make_signature(items: Array[IngredientData]) -> String:
	var ids := {}
	
	for item in items:
		ids[item.id] = true
	
	var unique_ids := ids.keys()
	unique_ids.sort()
	
	return "|".join(unique_ids)
