extends PanelContainer

@onready var item_grid: GridContainer = $MarginContainer/IngredientGrid

var inventory_slot_scene = preload("res://scenes/inv_slot_ui.tscn")
var inventory_slots_by_item: Dictionary = {}

var selector := SelectionController.new()

func _ready() -> void:
	SignalBus.change_ui_ingredient.connect(update)
	
	_build_inventory_ui()

func _build_inventory_ui() -> void:
	var total_items = IngDatabase.catalog_data.size()
	var inv_columns = item_grid.columns
	var slots_to_add = ceili(float(total_items) / float(inv_columns)) * inv_columns
	
	var owned_items = Inventory.ingredients.keys()
	for n in range(slots_to_add):
		var slot : ItemSlot = inventory_slot_scene.instantiate()
		item_grid.add_child(slot)
		slot.num_label.visible = false
		if n < owned_items.size():
			var item_id = owned_items[n]
			slot.setup_ui_slot(item_id, selector)
			inventory_slots_by_item[item_id] = slot

func update(item_id: String) -> void:
	var slot: ItemSlot = inventory_slots_by_item.get(item_id)
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
