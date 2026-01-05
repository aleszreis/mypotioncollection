extends Button
class_name ItemSlot

var item_data: IngredientData
var selector: SelectionController
var inventory := Inventory

@onready var sprite: TextureRect = $TextureRect
@onready var num_label: Label = $Label

func setup_ui_slot(item: IngredientData, selection_controller: SelectionController) -> void:
	item_data = item
	selector = selection_controller
	
	sprite.texture = item.icon
	num_label.text = str(inventory.get_item_count(item))
	
	toggle_mode = true
	button_pressed = false
	
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	selector.move_item(item_data)
	
func update_quantity() -> void:
	var value = inventory.get_item_count(item_data)
	num_label.text = str(value)
	num_label.visible = value >= 1
