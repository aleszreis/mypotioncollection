# Guarda as regras de aparição/chance de obter cada ingrediente
class_name IngredientRule
extends Resource

func is_available(context: Dictionary, entry: IngredientEntry) -> bool:
	return true

func weight_modifier(context: Dictionary, entry: IngredientEntry) -> float:
	return 1.0
