class_name PotionNameGenerator
extends Node

const BASE_NAME_BY_TYPE := {
	ItemTypes.Ingredient.FLOR: "Essência",
	ItemTypes.Ingredient.VEGETAL: "Detox",
	ItemTypes.Ingredient.FRUTA: "Suco",
	ItemTypes.Ingredient.ESPECIARIA: "Molho",
	ItemTypes.Ingredient.SEMENTE: "Óleo",
	ItemTypes.Ingredient.ANIMAL: "Caldo",
	ItemTypes.Ingredient.LIQUIDO: "Infusão",
	ItemTypes.Ingredient.MINERAL: "Extrato",
	ItemTypes.Ingredient.GEMA: "Pó",
	ItemTypes.Ingredient.PRODUZIDO: "Cerveja",
	ItemTypes.Ingredient.OBJETO: "Deconstructo",
}

func _generate_name(ingredients: Array[IngredientData]) -> String:
	var potion_type_name = _gen_potion_type_name(ingredients)
	return "%s de %s" % [potion_type_name, ingredients[0].display_name]

func _gen_potion_type_name(items: Array[IngredientData]):
	var type = _potion_type(items)
	var liquid_name = BASE_NAME_BY_TYPE.get(type)
	
	return liquid_name if liquid_name else "Poção"
	
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
