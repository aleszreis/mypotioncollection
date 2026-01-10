extends Button
class_name SelectionSlot

var item: IngredientData
var selector: SelectionController

@onready var sprite: TextureRect = $TextureRect

func setup_ui_slot(item_id: String, selection_controller: SelectionController) -> void:
	var data = IngDatabase.get_by_id(item_id)
	item = data
	sprite.texture = data.icon
	
	selector = selection_controller
	
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	SignalBus.ingredient_acquired.emit(item.id)
	selector.remove_from_selection(item.id)
	queue_free()
	
