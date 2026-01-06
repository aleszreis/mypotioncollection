class_name ProceduralItemGenerator
extends Node

	
func generate_item(signature: String, potion_name: String, ingredients: Array[String]) -> String:
	var rng := RandomNumberGenerator.new()
	rng.seed = signature.hash()
	
	var item := PotionData.new()
	item.id = _generate_id(signature)
	item.signature = signature
	item.discovered_at = Time.get_unix_time_from_system()
	item.rarity = _generate_rarity(ingredients)
	
	# PLACEHOLDERS — regras específicas entram depois
	item.display_name = potion_name
	#item.description = _generate_description(rng)
	#item.icon = _generate_icon(rng)
	
	Database.potions_data[item.id] = item
	
	return item.id

func _generate_id(signature: String) -> String:
	return "pot_" + str(abs(signature.hash()))

#func _generate_description(rng: RandomNumberGenerator) -> String:
	#return "Algo que surgiu de uma combinação improvável."

#func _generate_icon(rng: RandomNumberGenerator) -> Texture2D:
	#return preload("res://icons/placeholder.png")

func _generate_rarity(items: Array[String]) -> int:
	var avg_rarity = 0
	for id in items:
		avg_rarity += Database.get_ingredient_data(id).rarity
	return floor(avg_rarity / items.size())
