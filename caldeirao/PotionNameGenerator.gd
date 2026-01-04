class_name PotionNameGenerator
extends Node

const BASE_NAME_BY_TYPE := {
	ItemTypes.Ingredient.FLOR: "Essência de",
	ItemTypes.Ingredient.FRUTA: "Suco de",
	ItemTypes.Ingredient.ESPECIARIA: "Molho de",
	ItemTypes.Ingredient.GEMA: "Infusão de",
	ItemTypes.Ingredient.ESPECIAL: "Poção"
}

func _generate_name(ingredients: Array[IngredientData]) -> String:
	var unique_ingredients = _get_unique_ingredients(ingredients)
	var potion_type_name = _gen_potion_type_name(unique_ingredients)
	var potion_flavor_name = _gen_potion_flavor_name(unique_ingredients)
	return "%s %s" % [potion_type_name, potion_flavor_name]

func _get_unique_ingredients(ingredients: Array[IngredientData]) -> Array[IngredientData]:
	var i : Array[IngredientData] = []
	for ing in ingredients:
		if ing not in i:
			i.append(ing)
	return i

func _gen_potion_type_name(items: Array[IngredientData]) -> String:
	var type = _potion_type(items)
	var liquid_name = BASE_NAME_BY_TYPE.get(type)
	
	return liquid_name if liquid_name else "Mistura"
	
func _potion_type(items: Array[IngredientData]) -> int:
	"""Retorna o tipo de ingrediente mais utilizado"""
	var type_count = {}
	for item in items:
		var type = item.item_type
		if type_count.get(type):
			type_count[type] += 1
		else:
			type_count[type] = 1
	
	var max_value = 0
	for c in type_count.values():
		if c > max_value:
			max_value = c

	var result := []
	for t in type_count:
		if type_count[t] == max_value:
			result.append(t)
	
	return 999 if len(result) > 1 else result[0]

func _gen_potion_flavor_name(items: Array[IngredientData]) -> String:
	var items_count = items.size()
	
	if items_count == 2:
		return "%s%s" % [items[0].preffix, items[1].suffix]
	
	if items_count == 3:
		return "%s%s %s" % [items[0].preffix, items[1].suffix, items[2].adj]

	if items_count == 4:
		return "%s%s %s e %s" % [items[0].preffix, items[1].suffix, items[2].adj, items[3].adj]
	
	return items[0].adj if items[0].is_special() else items[0].display_name
