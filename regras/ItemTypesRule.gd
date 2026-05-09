class_name ItemTypesRule
extends Rule

func weight_modifier(context: Dictionary, entry: IngredientEntry) -> float:
	var item_type = entry.ingredient.item_type
	if context.cat_data.item_types.has(item_type):
		return 5.0
	return 1.0
