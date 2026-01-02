class_name SelectionController
extends Node

signal selection_changed(selected_items: Array[IngredientData])

var _selected: Dictionary = {} # id -> BaseItemData

func toggle_item(item: IngredientData) -> void:
	if _selected.has(item.id):
		_selected.erase(item.id)
	else:
		_selected[item.id] = item
	
	_emit_change()

func clear() -> void:
	_selected.clear()
	_emit_change()

func get_selected_items() -> Array[IngredientData]:
	var result: Array[IngredientData] = []
	
	for item in _selected.values():
		result.append(item)
	
	return result

func has_selection() -> bool:
	return not _selected.is_empty()
	
func _emit_change() -> void:
	selection_changed.emit(get_selected_items())
