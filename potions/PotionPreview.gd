extends PanelContainer

@onready var name_label: Label = $MarginContainer/PotionPreviewContainer/NameLabel
@onready var sprite_preview: TextureRect = $MarginContainer/PotionPreviewContainer/SpritePreview

var unknown_potion = load("res://potions/sprites/unknown_potion.png")

var RARITY = {
	0: "comum",
	1: "comum",
	2: "incomum",
	3: "raro",
	4: "lendário!",
	5: "exclusivo!"
}

func _ready():
	hide()

func update_potion_preview(items: Array[String]) -> void:
	if not items:
		hide()
		name_label.text = ""
		sprite_preview.texture = unknown_potion
		return
	
	show()
	var signature := SelectionNormalizer.make_signature(items)
	var potion = CreationRegistry.potion_is_known(signature)
	if potion:
		name_label.text = potion.display_name
		sprite_preview.texture = potion.icon
	else:
		name_label.text = "????"
		sprite_preview.texture = unknown_potion

func _on_clear_button_pressed() -> void:
	update_potion_preview([])

func _on_close_button_pressed() -> void:
	hide()
