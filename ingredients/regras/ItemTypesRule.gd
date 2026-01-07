class_name ItemTypesRule
extends IngredientRule

func weight_modifier(context: Dictionary, entry: IngredientEntry) -> float:
	var item_type = Database.ingredients_data[entry.ingredient_id].item_type
	if item_type == context.cat_data.favorite_item_type:
		return 5.0
	return 1.0
