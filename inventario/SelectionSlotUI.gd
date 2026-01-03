extends Button
class_name SelectionSlot

var item_data: IngredientData
var selector: SelectionController
var inventory := Inventory

@onready var sprite: TextureRect = $TextureRect

func setup_ui_slot(item: IngredientData, selection_controller: SelectionController) -> void:
	item_data = item
	sprite.texture = item.icon
	
	selector = selection_controller
	
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	Inventory.add_base_item(item_data)
	selector.remove_from_selection(item_data)
	queue_free()
	
