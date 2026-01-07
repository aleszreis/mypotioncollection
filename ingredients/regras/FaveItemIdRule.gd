class_name FaveItemIdRule
extends IngredientRule

func weight_modifier(context: Dictionary, entry: IngredientEntry) -> float:
	if entry.ingredient_id == Database.get_cat_data(context.cat_data).favorite_item_id:
		return 5.0
	return 1.0
