extends Control

@onready var item_grid: GridContainer = $HBoxContainer/CenterColumn/NinePatchRect/IngredientGrid
@onready var create_button: TextureButton = $HBoxContainer/CenterColumn/CenterCauldron/CreateItemButton
@onready var bowls_container: VBoxContainer = $HBoxContainer/LeftColumn/BowlsContainer
@onready var selected_grid = $HBoxContainer/CenterColumn/CenterSelected/SelectedIngredientsGrid
@onready var potion_preview = $HBoxContainer/CenterColumn/Spacer/PotionPreviewContainer

var inventory_slot_scene = preload("res://scenes/inv_slot_ui.tscn")
var inventory_slots_by_item: Dictionary = {}

var selection_slot_scene = preload("res://scenes/selec_slot_ui.tscn")

var offline_gains_scene = preload("res://scenes/offline_gains.tscn").instantiate()

var selector := SelectionController.new()

func _ready() -> void:
	selector.selected_item.connect(_on_item_selected)
	selector.deselected_item.connect(_on_item_deselected)
	SignalBus.change_ui_ingredient.connect(_update_inventory_ui)
	
	_build_bowls_buttons()
	_build_inventory_ui()

func _build_inventory_ui() -> void:
	var total_items = IngDatabase.catalog_data.size()
	var inv_columns = item_grid.columns
	var slots_to_add = ceili(float(total_items) / float(inv_columns)) * inv_columns
	
	var owned_items = Inventory.ingredients.keys()
	for n in range(slots_to_add):
		var slot := inventory_slot_scene.instantiate()
		item_grid.add_child(slot)
		slot.num_label.visible = false
		if n < owned_items.size():
			var item_id = owned_items[n]
			slot.setup_ui_slot(item_id, selector)
			inventory_slots_by_item[item_id] = slot

func _update_inventory_ui(item_id: String) -> void:
	var slot = inventory_slots_by_item.get(item_id)
	var owned_count = Inventory.get_item_count(item_id)
	
	# Se item já existe e quantidade continua maior que 0, atualiza label
	if slot and owned_count > 0:
		slot.update_quantity()
	
	# Se item existia, mas quantidade agora é 0, remove item do slot
	elif slot and owned_count <= 0:
		slot.clear_slot()
		inventory_slots_by_item.erase(item_id)
	
	# Se item não existia, adiciona ao primeiro slot vazio
	elif not slot:
		var empty_slots = item_grid.get_children().filter(func(s: ItemSlot): return s.item_id == "")
		if empty_slots.size() <= 0:
			push_error("MainUI.gd: Erro adicionando item ao inventário - nenhum slot vazio encontrado")
		empty_slots[0].setup_ui_slot(item_id, selector)
		inventory_slots_by_item[item_id] = empty_slots[0]

func _build_bowls_buttons() -> void:
	var bowls_ids = FoodBowlManager.bowls.keys()
	for bowl_id in bowls_ids:
		var bowl_btn = BowlButton.new()
		bowl_btn.bowl_id = bowl_id
		bowls_container.add_child(bowl_btn)

func _on_create_potion_pressed() -> void:
	if not selector.has_selection():
		print("MainUI.gd: Nenhum item selecionado")
		return
	
	SignalBus.craft_pressed.emit(selector)
	
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
