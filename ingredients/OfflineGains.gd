extends CenterContainer

@onready var inventory_display: HFlowContainer = $VBoxContainer/MarginContainerInv/OfflineInventory

var inventory_slot_scene = preload("res://scenes/inv_slot_ui.tscn")

func display_items(offline_items: Dictionary) -> void:
	for item_id in offline_items.keys():
		var slot := inventory_slot_scene.instantiate()
		inventory_display.add_child(slot)
		
		var item_data = IngDatabase.get_by_id(item_id)
		slot.item_id = item_data.id
		slot.sprite.texture = item_data.icon
		slot.num_label.text = str(offline_items[item_id])
		
func _on_button_pressed() -> void:
	queue_free()
