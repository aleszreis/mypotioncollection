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
