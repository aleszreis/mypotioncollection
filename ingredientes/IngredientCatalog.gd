# Guarda os dados de todos os ingredientes que existem no jogo
extends Node

var entries: Array[IngredientEntry] = []

func _ready():
	_populate_entries()
	
func _populate_entries():
	for item in ImportItemData.ingredients_data.values():
		var item_data = IngredientData.new()
		item_data.id = item.id
		item_data.display_name = item.display_name
		item_data.icon = load(item.icon)
		item_data.item_type = ItemTypes.Ingredient[item.item_type.to_upper()]
		item_data.rarity = item.rarity
		
		var entry = IngredientEntry.new()
		entry.ingredient = item_data
		entry.base_weight = item.base_weight
		#entry.rules = [] # TODO: formatar as regras quando forem implementadas
		
		entries.append(entry)

func roll_ingredient(context: Dictionary, rng: RandomNumberGenerator) -> IngredientData:
	var pool: Array[IngredientEntry] = []
	var weights: Array[float] = []

	for entry in entries:
		if not _passes_rules(entry, context):
			continue
		
		var weight := entry.base_weight * _apply_modifiers(entry, context)
		if weight <= 0:
			continue
		
		pool.append(entry)
		weights.append(weight)

	return _weighted_pick(pool, weights, rng).ingredient

func _weighted_pick(
	entries: Array[IngredientEntry],
	weights: Array[float],
	rng: RandomNumberGenerator
) -> IngredientEntry:
	
	var total := 0.0
	for w in weights:
		total += w
	
	if total <= 0.0:
		push_error("Weighted pick chamado com peso total zero.")
		return entries[0]
	
	var roll := rng.randf() * total
	
	for i in range(entries.size()):
		roll -= weights[i]
		if roll <= 0.0:
			return entries[i]
	
	# fallback de segurança
	return entries.back()

func _passes_rules(entry: IngredientEntry, context: Dictionary) -> bool:
	for rule in entry.rules:
		if not rule.is_available(context):
			return false
	return true

func _apply_modifiers(entry: IngredientEntry, context: Dictionary) -> float:
	var result := 1.0
	for rule in entry.rules:
		result *= rule.weight_modifier(context)
	return result
