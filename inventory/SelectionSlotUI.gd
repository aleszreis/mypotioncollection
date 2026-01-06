extends Button
class_name SelectionSlot

var item: String
var selector: SelectionController
var inventory := Inventory

@onready var sprite: TextureRect = $TextureRect

func setup_ui_slot(item_id: String, selection_controller: SelectionController) -> void:
	item = item_id
	sprite.texture = Database.get_ingredient_data(item_id).icon
	
	selector = selection_controller
	
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	Inventory.add_base_item(item)
	selector.remove_from_selection(item)
	queue_free()
	
