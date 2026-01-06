class_name SelectionController
extends Node

signal selected_item(item: String)
signal deselected_item()

var MAX_SELECTION := 4
var _selected: Array[String] = []

func move_item(item_id: String) -> void:
	if _selected.size() < MAX_SELECTION:
		_selected.append(item_id)
		Inventory.remove_item(item_id)
	
		_emit_change()

func clear() -> void:
	_selected.clear()

func get_selected_items() -> Array[String]:
	var filtered_items = _selected.filter(func(n): return Database.get_ingredient_data(n).item_type == ItemTypes.Ingredient.ESPECIAL)
	return filtered_items if filtered_items.size() > 0 else _selected

func has_selection() -> bool:
	return not _selected.is_empty()
	
func _emit_change() -> void:
	selected_item.emit(_selected[-1])

func remove_from_selection(item_id: String):
	var item_index = _selected.find(item_id)
	_selected.pop_at(item_index)
	deselected_item.emit()
