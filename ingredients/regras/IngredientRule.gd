# Guarda as regras de aparição/chance de obter cada ingrediente
class_name IngredientRule
extends Resource

func is_available(context: Dictionary, entry: IngredientEntry) -> bool:
	var cat_available_items = context.cat_data.item_types.map(func(t): return int(t))
	var item_type = entry.ingredient.item_type
	if cat_available_items.has(item_type):
		return true
	return false

func weight_modifier(context: Dictionary, entry: IngredientEntry) -> float:
	return 1.0
