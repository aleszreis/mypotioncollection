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
@export var can_be_fetched: bool = true

func is_special():
	return item_type == ItemTypes.Ingredient.ESPECIAL

func serialize() -> Dictionary:
	return {
		'id': id,
		'display_name': display_name,
		'icon': icon,
		'item_type': item_type,
		'rarity': rarity,
		'preffix': preffix,
		'suffix': suffix,
		'adj': adj,
		'color': color,
	}

func create_from_dict(data: Dictionary) -> void:
	id = data.id
	display_name = data.display_name
	icon = load("res://ingredients/sprites/%s.png" % data.icon_name)
	item_type = ItemTypes.Ingredient[data.item_type.to_upper()]
	rarity = data.rarity
	preffix = data.preffix
	suffix = data.suffix
	adj = data.adj
	color = data.color
