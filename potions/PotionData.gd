class_name PotionData
extends Resource

@export var signature: String          # osso|pena|pedra

@export var display_name: String
@export var description: String
@export var rarity: int

@export var icon: Texture2D

func serialize() -> Dictionary:
	return {
		'signature': signature,
		'display_name': display_name,
		'icon': icon,
		'rarity': rarity,
		'description': description,
	}

func create_from_dict(data: Dictionary) -> void:
	signature = data.signature
	display_name = data.display_name
	icon = data.icon
	rarity = data.rarity
	description = data.description
