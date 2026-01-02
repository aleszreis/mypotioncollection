class_name ProceduralItemGenerator
extends Node

func generate_item(signature: String) -> PotionData:
	var rng := RandomNumberGenerator.new()
	rng.seed = signature.hash()
	
	var item := PotionData.new()
	item.id = _generate_id(signature)
	item.signature = signature
	item.discovered_at = Time.get_unix_time_from_system()
	
	# PLACEHOLDERS — regras específicas entram depois
	item.display_name = _generate_name(rng)
	item.description = _generate_description(rng)
	#item.icon = _generate_icon(rng)
	
	return item

func _generate_id(signature: String) -> String:
	return "item_" + str(abs(signature.hash()))

func _generate_name(rng: RandomNumberGenerator) -> String:
	var names = ["Relíquia Silenciosa", "Objeto Esquecido", "Forma Estranha"]
	return names[rng.randi_range(0, names.size() - 1)]

func _generate_description(rng: RandomNumberGenerator) -> String:
	return "Algo que surgiu de uma combinação improvável."

#func _generate_icon(rng: RandomNumberGenerator) -> Texture2D:
	#return preload("res://icons/placeholder.png")
