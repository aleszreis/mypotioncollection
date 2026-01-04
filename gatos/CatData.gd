# Informações de cada possível gato visitante
class_name CatData
extends Resource

@export var id: String
@export var name: String

@export var accepted_foods: Array[String] # ID dos FoodTypes aceitos
@export var base_travel_time: float = 10.0
@export var food_efficiency: float = 1.0

@export var favorite_item_type: ItemTypes.Ingredient
@export var favorite_item_id: String

@export var rules: Array[IngredientRule] = []
