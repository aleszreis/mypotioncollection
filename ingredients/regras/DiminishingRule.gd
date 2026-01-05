class_name DiminishingRule
extends IngredientRule

func weight_modifier(context: Dictionary, entry: IngredientEntry) -> float:
	var owned : int = context.inventory.get_item_count(entry.ingredient)
	return max((100.0 - float(owned)) / 100.0, 0.01)
