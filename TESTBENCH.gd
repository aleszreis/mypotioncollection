extends Control

var inventory := Inventory

@onready var item_grid: GridContainer = $HBoxContainer/InventoryContainer/IngredientGrid
@onready var create_button: Button = $HBoxContainer/CraftContainer/CenterContainer/CreateItemButton
@onready var bowls: VBoxContainer = $HBoxContainer/BowlContainer

@onready var bowl_manager: FoodBowlManager = $Game/FoodBowlManager

var ui_slot_scene = preload("res://cenas/inv_slot_ui.tscn")
var slots_by_item_id: Dictionary = {}

var selector := SelectionController.new()

func _ready() -> void:
	add_child(selector)
	
	selector.selection_changed.connect(_on_selection_changed)
	SignalBus.item_acquired.connect(_update_inventory_ui)
	
	_build_inventory_ui()

func _build_inventory_ui() -> void:
	for item in inventory.ingredients.values():
		_update_inventory_ui(item['data'])

func _update_inventory_ui(item: IngredientData) -> void:
	if slots_by_item_id.get(item.id):
		slots_by_item_id[item.id].update_quantity()
		return
	var slot := ui_slot_scene.instantiate()
	item_grid.add_child(slot)
	slot.setup_ui_slot(item, selector)
	slots_by_item_id[item.id] = slot

func _on_create_potion_pressed() -> void:
	if not selector.has_selection():
		print("Nenhum item selecionado")
		return
	
	var items := selector.get_selected_items()
	if len(items) < 2:
		print("Apenas 1 item selecionado")
		return
	
	var signature := SelectionNormalizer.make_signature(items)
	var created := CreationRegistry.get_or_create(signature)
	
	inventory.add_created_item(created)
	
	print("Criado:", created.id, "|", created.display_name)


func _on_selection_changed(items: Array[IngredientData]) -> void:
	var selected_ids := {}
	for i in items:
		selected_ids[i.id] = true
	
	for slot in item_grid.get_children():
		slot.button_pressed = selected_ids.has(slot.item_data.id)
