class_name Database
extends Node

var FOLDER_PATH = "res://z_json_files_to_import/Godot Item Data - "

func _parse_to_json(file_name):
	var file = FileAccess.open(FOLDER_PATH + file_name, FileAccess.READ)
	var data_as_text = file.get_as_text()
	file.close()
	return JSON.parse_string(data_as_text)

func _format_string_to_array(s: String) -> Array[String]:
	var a: Array[String] = []
	for part in s.split(","):
		a.append(part.strip_edges())
	return a

func _format_rules(rules_as_string: String) -> Array[Rule]:
	var rules_arr = _format_string_to_array(rules_as_string)
	
	var RULES = {
		"diminishing_rule": DiminishingRule,
		"extra_diminishing_rule": ExtraDiminishingRule,
		"item_types": ItemTypesRule,
		"fave_item_id_rule": FaveItemIdRule,
		}

	var rules_formatted: Array[Rule] = []
	for i in rules_arr:
		if RULES.has(i):
			rules_formatted.append(RULES[i].new())

	return rules_formatted
