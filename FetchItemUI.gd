extends Control

@onready var fetch_in_progress: Panel = $FetchInProgress
@onready var cat_sprite: AnimatedSprite2D = $FetchInProgress/VBoxContainer/Control/AnimatedSprite2D
@onready var fetch_progress_label: Label = $FetchInProgress/VBoxContainer/ProgressLabel

@onready var fetch_enabled: Panel = $FetchEnabled
@onready var inventory_ui: Control = $InventoryUI
@onready var items_list: OptionButton = $FetchEnabled/VBoxContainer/ChooseItem
@onready var cats_list: OptionButton = $FetchEnabled/VBoxContainer/ChooseCat
@onready var progress_bar = $FetchEnabled/VBoxContainer/ProgressBar
@onready var progress_label: Label = $FetchEnabled/VBoxContainer/ProgressLabel
@onready var selected_grid: GridContainer = $FetchEnabled/VBoxContainer/ItemsToConsume
@onready var send_button: Button = $FetchEnabled/VBoxContainer/MarginContainerBtn/HBoxContainer/SendButton

var all_cats_data = []
var selected_cat : CatInstance

var inventory_slot_scene = preload("res://scenes/inv_slot_ui.tscn")

var selection_slot_scene = preload("res://scenes/selec_slot_ui.tscn")
var selector : SelectionController

func _ready():
	selector = inventory_ui.selector
	selector.MAX_SELECTION = 16
	selector.selected_item.connect(_on_fuel_selected)
	selector.deselected_item.connect(_on_fuel_deselected)
	
	items_list.clear()
	
	_populate_items()
	_populate_cats()
	
	var item = items_list.get_item_metadata(0)
	progress_bar.max_value = item.rarity * 5
	_update_progress()

func close():
	selector.deselect_all()
	get_tree().change_scene_to_file("res://scenes/main_ui.tscn")

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
	all_cats_data.sort_custom(func(a,b): return a.cat_data.display_name < b.cat_data.display_name)
	for cat: CatInstance in all_cats_data:
		if item.item_type not in cat.cat_data.item_types:
			continue
			
		cats_list.add_item(cat.cat_data.display_name)
		cats_list.set_item_metadata(-1, cat)
		if cat.is_busy:
			cats_list.set_item_disabled(-1, true)
	selected_cat = cats_list.get_item_metadata(0)

func _on_cat_selected(index: int) -> void:
	selected_cat = cats_list.get_item_metadata(index)
	_update_progress()

func _clear_cats() -> void:
	cats_list.clear()

func _on_send_button_pressed():
	var cat: CatInstance = cats_list.get_item_metadata(cats_list.get_selected_id())
	var item: IngredientData = items_list.get_item_metadata(items_list.get_selected_id())
	var now := Time.get_unix_time_from_system() + 86400 # Adds one day
	
	FoodAttractionSystem.schedule_cat(cat, item.id, now)
	
	print("FetchItemUI.gd: Sending cat %s to fetch item %s" % [cat.cat_data.display_name, item.display_name])
	
	selector.clear()
	close()
	# TODO: verify that cat is gone, busy and with correct chosen_item
	
	# TODO: disallow new fetch send - wait until cat comes back
	#fetch_enabled.hide()
	#fetch_in_progress.show()

func _on_cancel_button_pressed():
	close()

func _on_item_selected(index: int) -> void:
	_populate_cats()
	
	var item = items_list.get_item_metadata(index)
	progress_bar.max_value = item.rarity * 5
	_update_progress()

func _update_progress() -> void:
	var fuel_value = _calculate_fuel_value()
	progress_bar.value = fuel_value
	progress_label.text = "%s / %s" % [fuel_value, int(progress_bar.max_value)]
	send_button.disabled = fuel_value < int(progress_bar.max_value)

func _on_fuel_selected(item_id: String) -> void:
	# Cria slot
	var slot : SelectionSlot = selection_slot_scene.instantiate()
	selected_grid.add_child(slot)
	slot.setup_ui_slot(item_id, selector)
	
	# Atualiza a barra de progresso
	_update_progress()

func _calculate_fuel_value() -> int:
	var fuel = selector.get_selected_items()
	var value = 0
	
	for item_id: String in fuel:
		var item_rarity = IngDatabase.get_by_id(item_id).rarity
		if item_id == selected_cat.cat_data.favorite_item_id:
			value += (item_rarity * 3)
		else:
			value += item_rarity
	return value

func _on_fuel_deselected() -> void:
	_update_progress()

func _get_cat_fetching(cats_data: Array[CatInstance]) -> Array[CatInstance]:
	return cats_data.filter(func(c): return c.is_fetching)

func _set_fetch_info(cat: CatInstance) -> void:
	if cat:
		cat_sprite.sprite_frames = cat.cat_data.walking_sprite
		cat_sprite.play()
		var formatted_time = _set_remaining_time(cat.next_available_time)
		fetch_progress_label.text = "%s retornará em %s com o item %s." % [cat.cat_data.display_name, formatted_time, IngDatabase.get_by_id(cat.chosen_item).display_name]
		
		fetch_enabled.hide()
		fetch_in_progress.show()
	else:
		fetch_in_progress.hide()
		fetch_enabled.show()

func _set_remaining_time(end_time) -> String:
	var now = Time.get_unix_time_from_system()
	var remaining_time = end_time - now
	var hours: int = int(remaining_time / 3600)
	var minutes: int = int(remaining_time / 60) % 60
	var seconds: int = int(remaining_time) % 60
	return "%02d:%02d:%02d" % [hours, minutes, seconds]

func _process(delta) -> void:
	all_cats_data = GameManager.cats_instances.duplicate()
	var fetching = _get_cat_fetching(all_cats_data)
	for cat in fetching:
		_set_fetch_info(cat)
