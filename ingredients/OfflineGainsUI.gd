extends PanelContainer

@onready var inventory_display: GridContainer = $MarginContainer/VBoxContainer/OfflineInventory

var inventory_slot_scene = preload("res://scenes/inv_slot_ui.tscn")

func _ready():
	#var x = get_viewport().size.x
	#var y = x / 2
	#size = Vector2(x, y)
	
	_process_offline_progress()

func display_items(offline_items: Dictionary) -> void:
	visible = true
	for item_id in offline_items.keys():
		var slot := inventory_slot_scene.instantiate()
		inventory_display.add_child(slot)
		
		var item_data = IngDatabase.get_by_id(item_id)
		slot.item_id = item_data.id
		slot.sprite.texture = item_data.icon
		slot.bg_sprite.texture = load("res://inventory/sprites/off-inventory-bg.png")
		slot.num_label.text = str(offline_items[item_id])
		
func _on_button_pressed() -> void:
	queue_free()

func _process_offline_progress() -> void:
	var acquired_items = GameManager.process_offline_progress()
	if acquired_items.is_empty():
		queue_free()
		return
		
	display_items(acquired_items)
