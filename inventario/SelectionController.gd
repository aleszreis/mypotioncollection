class_name SelectionController
extends Node

signal selection_changed(selected_items: Array[IngredientData])

var _selected: Array[IngredientData] = []

func move_item(item: IngredientData) -> void:
	_selected.append(item)
	Inventory.remove_items([item])
	
	_emit_change()

func clear() -> void:
	_selected.clear()

func get_selected_items() -> Array[IngredientData]:
	return _selected
	#var result: Array[IngredientData] = []
	#
	#for item in _selected.values():
		#result.append(item)
	#
	#return result

func has_selection() -> bool:
	return not _selected.is_empty()
	
func _emit_change() -> void:
	selection_changed.emit(_selected[-1])

func remove_from_selection(item: IngredientData):
	var item_index = _selected.find(item)
	_selected.pop_at(item_index)
