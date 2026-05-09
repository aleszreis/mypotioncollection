extends Control

@onready var inventory_ui: Control = $InventoryUI
@onready var create_button: TextureButton = $CreateItemButton
@onready var selected_grid = $SelectedIngredientsGrid
@onready var potion_preview = $PotionPreview

var bowl_btn_scene = preload("res://scenes/bowl_button.tscn")
@onready var bowls_container: VBoxContainer = $BowlsContainer

@onready var offline_gains: PanelContainer = $"../OfflineGains"

var selector : SelectionController
var selection_slot_scene = preload("res://scenes/selec_slot_ui.tscn")

func _ready() -> void:
	selector = inventory_ui.selector
	
	selector.selected_item.connect(_on_item_selected)
	selector.deselected_item.connect(_on_item_deselected)
	SignalBus.show_offline_gains.connect(_show_offline_gains)

	_build_bowls_buttons()

func _build_bowls_buttons() -> void:
	var bowls_ids = FoodBowlManager.bowls.keys()
	for bowl_id in bowls_ids:
		var bowl_btn = bowl_btn_scene.instantiate()
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
	var slot : SelectionSlot = selection_slot_scene.instantiate()
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

func _on_fetch_item_btn_pressed() -> void:
	selector.deselect_all()
	get_tree().change_scene_to_file("res://scenes/fetch_item.tscn")
	
func _show_offline_gains() -> void:
	offline_gains.display_items()
