extends Button
class_name ItemSlot

var item_id: String
var selector: SelectionController
var inventory := Inventory

@onready var sprite: TextureRect = $TextureRect
@onready var num_label: Label = $Label

func setup_ui_slot(item: String, selection_controller: SelectionController) -> void:
	selector = selection_controller
	
	var item_data = IngDatabase.get_by_id(item)
	item_id = item_data.id
	sprite.texture = item_data.icon
	num_label.text = str(inventory.get_item_count(item_id))
	
	toggle_mode = true
	button_pressed = false
	
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	selector.move_item(item_id)
	
func update_quantity() -> void:
	var value = inventory.get_item_count(item_id)
	num_label.text = str(value)
	num_label.visible = value >= 1
