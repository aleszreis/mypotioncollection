class_name DiminishingRule
extends IngredientRule

@export var threshold: int = 100
@export var penalty: float = 0.5

func weight_modifier(context: Dictionary) -> float:
	var owned : int = context.inventory_count
	return max((100 - owned) / 100, 0.01)
