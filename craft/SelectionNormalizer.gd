class_name SelectionNormalizer
extends Node

static func make_signature(items: Array[String]) -> String:
	var ids := {}
	
	for id in items:
		ids[id] = true
	
	var unique_ids := ids.keys()
	unique_ids.sort()
	
	return "|".join(unique_ids)
