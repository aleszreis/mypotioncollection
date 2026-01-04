extends Control

var inventory := Inventory

@onready var item_grid: GridContainer = $HBoxContainer/InventoryContainer/IngredientGrid
@onready var create_button: TextureButton = $HBoxContainer/CraftContainer/CenterContainer/CreateItemButton
@onready var bowls: VBoxContainer = $HBoxContainer/BowlContainer
@onready var selected_grid: GridContainer = $HBoxContainer/CraftContainer/SelectedIngredientsGrid

@onready var bowl_manager: FoodBowlManager = $Game/FoodBowlManager

var inventory_slot_scene = preload("res://cenas/inv_slot_ui.tscn")
var inventory_slots_by_item: Dictionary = {}

var selection_slot_scene = preload("res://cenas/selec_slot_ui.tscn")
var selection_slots_by_item: Dictionary = {}

var selector := SelectionController.new()

func _ready() -> void:
	add_child(selector)
	
	selector.selection_changed.connect(_on_selection_changed)
	SignalBus.changed_item.connect(_update_inventory_ui)
	
	_build_inventory_ui()

func _build_inventory_ui() -> void:
	for item in inventory.ingredients.values():
		_update_inventory_ui(item['data'])

func _update_inventory_ui(item: IngredientData) -> void:
	# Se item já existe e quantidade continua maior que 0, atualiza label
	if inventory_slots_by_item.get(item.id) and inventory.get_item_count(item) > 0:
		inventory_slots_by_item[item.id].update_quantity()
	
	# Se item existia, mas quantidade agora é 0, remove slot
	elif inventory_slots_by_item.get(item.id) and inventory.get_item_count(item) <= 0:
		inventory_slots_by_item[item.id].queue_free()
	
	# Se item não existia, adiciona slot
	elif not inventory_slots_by_item.get(item.id):
		var slot := inventory_slot_scene.instantiate()
		item_grid.add_child(slot)
		slot.setup_ui_slot(item, selector)
		inventory_slots_by_item[item.id] = slot

func _on_create_potion_pressed() -> void:
	if not selector.has_selection():
		print("MainUI.gd: Nenhum item selecionado")
		return
	
	var items := selector.get_selected_items()
	if len(items) < 2:
		print("MainUI.gd: Apenas 1 item selecionado")
		return
	
	var signature := SelectionNormalizer.make_signature(items)
	var potion := CreationRegistry.get_or_create(signature, items)
	
	inventory.add_created_item(potion)
	_clear_selected_slots_ui()
	selector.clear()
	
	print("MainUI.gd: Criado:", potion.id, " | ", potion.display_name)

func _on_selection_changed(item: IngredientData) -> void:
	# Cria slot
	var slot := selection_slot_scene.instantiate()
	selected_grid.add_child(slot)
	slot.setup_ui_slot(item, selector)
	
	# Outros#####
	#var selected_ids := {}
	#for i in items:
		#selected_ids[i.id] = true
	#
	#for slot in item_grid.get_children():
		#slot.button_pressed = selected_ids.has(slot.item_data.id)

func _clear_selected_slots_ui():
	for s in selected_grid.get_children():
		s.queue_free()
