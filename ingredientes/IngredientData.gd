# Guarda os dados do ingrediente que aparece no inventário
class_name IngredientData
extends Resource

@export var id: String
@export var display_name: String
@export var icon: Texture2D
@export var item_type: ItemTypes.Ingredient
@export var rarity: int
