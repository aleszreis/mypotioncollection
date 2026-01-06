extends Panel

@onready var intro_label : Label = $VBoxContainer/IntroLabel
@onready var name_label : Label = $VBoxContainer/NameLabel
@onready var rarity_label : Label = $VBoxContainer/RarityLabel

var RARITY = {
	0: "comum",
	1: "comum",
	2: "incomum",
	3: "raro",
	4: "lendário!",
	5: "exclusivo!"
}

func update_potion_preview(items: Array[IngredientData]) -> void:
	if not items:
		intro_label.text = "Nada sendo criado por enquanto..."
		name_label.text = ""
		rarity_label.text = ""
		return
	
	var signature := SelectionNormalizer.make_signature(items)
	var potion = CreationRegistry.potion_is_known(signature)
	intro_label.text = "Você está criando..."
	if potion:
		name_label.text = potion.display_name
		rarity_label.text = "Item %s" % RARITY[potion.rarity]
	else:
		name_label.text = "uma mistura desconhecida!"


func _on_clear_button_pressed() -> void:
	update_potion_preview([])
