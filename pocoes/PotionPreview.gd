extends VBoxContainer

@onready var intro_label : Label = $IntroLabel
@onready var name_label : Label = $NameLabel

func update_potion_preview(items: Array[IngredientData]) -> void:
	if not items:
		intro_label.text = "Nada sendo criado por enquanto..."
		name_label.text = ""
		return
	
	var signature := SelectionNormalizer.make_signature(items)
	var potion = CreationRegistry.potion_is_known(signature)
	intro_label.text = "Você está criando..."
	if potion:
		name_label.text = potion.display_name
	else:
		name_label.text = "uma mistura desconhecida!"


func _on_clear_button_pressed() -> void:
	update_potion_preview([])
