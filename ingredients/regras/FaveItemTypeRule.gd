class_name FaveItemTypeRule
extends IngredientRule

func weight_modifier(context: Dictionary, entry: IngredientEntry) -> float:
	if entry.ingredient.item_type == context.cat_data.favorite_item_type:
		return 5.0
	return 1.0
