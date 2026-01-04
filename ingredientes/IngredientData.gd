# Guarda os dados do ingrediente que aparece no inventário
class_name IngredientData
extends Resource

@export var id: String
@export var display_name: String
@export var icon: Texture2D
@export var item_type: ItemTypes.Ingredient
@export var rarity: int
@export var preffix: String
@export var suffix: String
@export var adj: String
@export var color: String

func is_special():
	return item_type == ItemTypes.Ingredient.ESPECIAL
