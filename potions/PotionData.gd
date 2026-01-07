class_name PotionData
extends Resource

@export var id: String                 # pot_023
@export var signature: String          # osso|pena|pedra

@export var display_name: String
@export var description: String
@export var rarity: int

@export var icon: Texture2D

@export var discovered_at: int         # timestamp unix

func serialize() -> Dictionary:
	return {
		'id': id,
		'display_name': display_name,
		'icon': icon,
		'signature': signature,
		'rarity': rarity,
		'description': description,
		'discovered_at': discovered_at,
	}

func create_from_dict(data: Dictionary) -> void:
	id = data.id
	display_name = data.display_name
	icon = data.icon
	signature = data.signature
	rarity = data.rarity
	description = data.description
	discovered_at = data.discovered_at
