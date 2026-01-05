class_name SelectionController
extends Node

signal selected_item(item: IngredientData)
signal deselected_item(item: IngredientData)

var MAX_SELECTION := 4
var _selected: Array[IngredientData] = []

func move_item(item: IngredientData) -> void:
	if _selected.size() < MAX_SELECTION:
		_selected.append(item)
		Inventory.remove_items([item])
	
		_emit_change()

func clear() -> void:
	_selected.clear()

func get_selected_items() -> Array[IngredientData]:
	var filtered_items = _selected.filter(func(n): return n.item_type == ItemTypes.Ingredient.ESPECIAL)
	return filtered_items if filtered_items.size() > 0 else _selected

func has_selection() -> bool:
	return not _selected.is_empty()
	
func _emit_change() -> void:
	selected_item.emit(_selected[-1])

func remove_from_selection(item: IngredientData):
	var item_index = _selected.find(item)
	deselected_item.emit(_selected.pop_at(item_index))
