extends Control

@onready var item_grid = $HBoxContainer/InventoryContainer/IngredientGrid
@onready var create_button: TextureButton = $HBoxContainer/CraftContainer/CenterCauldron/CreateItemButton
@onready var bowls: VBoxContainer = $HBoxContainer/LeftSideContainer/BowlsContainer
@onready var selected_grid = $HBoxContainer/CraftContainer/CenterSelected/SelectedIngredientsGrid
@onready var potion_preview = $HBoxContainer/LeftSideContainer/PotionPreviewContainer

@onready var bowl_manager: FoodBowlManager = $Game/FoodBowlManager

var inventory_slot_scene = preload("res://scenes/inv_slot_ui.tscn")
var inventory_slots_by_item: Dictionary = {}

var selection_slot_scene = preload("res://scenes/selec_slot_ui.tscn")
var selection_slots_by_item: Dictionary = {}

var selector := SelectionController.new()

func _ready() -> void:
	add_child(selector)
	
	selector.selected_item.connect(_on_item_selected)
	selector.deselected_item.connect(_on_item_deselected)
	SignalBus.changed_item.connect(_update_inventory_ui)
	
	_build_inventory_ui()

func _build_inventory_ui() -> void:
	for item_id in Inventory.ingredients:
		_update_inventory_ui(item_id)

func _update_inventory_ui(item_id: String) -> void:
	# Se item já existe e quantidade continua maior que 0, atualiza label
	if inventory_slots_by_item.get(item_id) and Inventory.get_item_count(item_id) > 0:
		inventory_slots_by_item[item_id].update_quantity()
	
	# Se item existia, mas quantidade agora é 0, remove slot
	elif inventory_slots_by_item.get(item_id) and Inventory.get_item_count(item_id) <= 0:
		inventory_slots_by_item[item_id].queue_free()
	
	# Se item não existia, adiciona slot
	elif not inventory_slots_by_item.get(item_id):
		var slot := inventory_slot_scene.instantiate()
		item_grid.add_child(slot)
		slot.setup_ui_slot(item_id, selector)
		inventory_slots_by_item[item_id] = slot

func _on_create_potion_pressed() -> void:
	if not selector.has_selection():
		print("MainUI.gd: Nenhum item selecionado")
		return
	
	var items := selector.get_selected_items()
	var signature := SelectionNormalizer.make_signature(items)
	var potion := CreationRegistry.get_or_create(signature, items)
	
	Inventory.add_created_potion(potion.signature)
	potion_preview.update_potion_preview(selector.get_selected_items())
	_clear_selected_slots_ui()
	selector.clear()

func _on_item_selected(item_id: String) -> void:
	# Cria slot
	var slot := selection_slot_scene.instantiate()
	selected_grid.add_child(slot)
	slot.setup_ui_slot(item_id, selector)

	# Atualiza menu lateral
	potion_preview.update_potion_preview(selector.get_selected_items())

func _on_item_deselected() -> void:
	potion_preview.update_potion_preview(selector.get_selected_items())

func _clear_selected_slots_ui():
	for s in selected_grid.get_children():
		s.queue_free()
		
	# Atualiza menu lateral
	potion_preview.update_potion_preview(selector.get_selected_items())
