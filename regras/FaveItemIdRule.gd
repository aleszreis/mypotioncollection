class_name FaveItemIdRule
extends Rule

func weight_modifier(context: Dictionary, entry: IngredientEntry) -> float:
	if entry.ingredient.id == context.cat_data.favorite_item_id:
		return 5.0
	return 1.0
