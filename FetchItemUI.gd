extends Panel

@onready var items_list: OptionButton = $VBoxContainer/MarginContainerLbl/VBoxContainer/ChooseItem
@onready var cats_list: OptionButton = $VBoxContainer/MarginContainerLbl/VBoxContainer/ChooseCat
@onready var progress_bar = $VBoxContainer/MarginContainerLbl/VBoxContainer/ProgressBar
@onready var items_inv: GridContainer = $VBoxContainer/MarginContainerLbl/VBoxContainer/MarginContainerInv/ItemsToConsume

var inventory_slot_scene = preload("res://scenes/inv_slot_ui.tscn")

func _ready():
	_populate_items()
	_populate_cats()

func _populate_items() -> void:
	var ingredients = IngDatabase.ingredients_data.values().duplicate(true)
	ingredients.sort_custom(func(a,b): return a.rarity < b.rarity)
	
	for ingredient in ingredients:
		if ingredient.can_be_fetched:
			items_list.add_icon_item(ingredient.icon, ingredient.display_name)
			items_list.set_item_metadata(-1, ingredient)
	
func _populate_cats() -> void:
	_clear_cats()
	
	var item: IngredientData = items_list.get_selected_metadata()
	var cats = CatDatabase.cats_instances.duplicate(true)
	cats.sort_custom(func(a,b): return a.cat_data.display_name < b.cat_data.display_name)
	for cat: CatInstance in cats:
		if item.item_type not in cat.cat_data.item_types:
			continue
			
		cats_list.add_item(cat.cat_data.display_name)
		cats_list.set_item_metadata(-1, cat)
		if cat.is_busy:
			cats_list.set_item_disabled(-1, true)

func _clear_cats() -> void:
	cats_list.clear()

func update_progress_bar():
	pass
	
func _on_send_button_pressed():
	## Check if cat is busy before sending
	pass

func _on_cancel_button_pressed():
	queue_free()

func _on_item_selected(index: int) -> void:
	_populate_cats()
