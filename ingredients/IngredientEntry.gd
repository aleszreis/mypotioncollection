# Guarda os dados de chance de obter cada ingrediente
class_name IngredientEntry
extends Resource

@export var ingredient_id: String
@export var base_weight: float = 1.0
@export var rules: Array[IngredientRule] = []
