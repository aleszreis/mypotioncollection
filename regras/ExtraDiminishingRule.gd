class_name ExtraDiminishingRule
extends Rule

func weight_modifier(context: Dictionary, entry: IngredientEntry) -> float:
	var owned : int = Inventory.get_item_count(entry.ingredient.id)
	return max((4.0 - float(owned)) / 100.0, 0.01)
