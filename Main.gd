extends Node

@onready var food_system: FoodAttractionSystem = $FoodAttractionSystem
@onready var offline_display = $"../OfflinePopupContainer"


func _ready() -> void:
	_spawn_cats()
	#_DEBUG_spawn_inventory_items()
	_process_offline_progress()
	
	SignalBus.craft_pressed.connect(_craft_potion)

func _process(_delta: float) -> void:
	var now := Time.get_unix_time_from_system()
	food_system.process_time(now)

# --------------------------------------------------

func _spawn_cats() -> void:
	var all_cats_data = CatDatabase.cats_data.values()
	
	for cat in all_cats_data:
		var cat_instance := CatInstance.new()
		cat_instance.cat_data = CatDatabase.get_by_id(cat.id)
		food_system.cats.append(cat_instance)

# --------------------------------------------------

func _DEBUG_spawn_inventory_items() -> void:
	for entry in IngredientCatalog.entries:
		for i in range(10):
			Inventory.add_base_item(entry.ingredient.id)

# --------------------------------------------------

func _process_offline_progress() -> void:
	var next_event = _get_next_event()
	
	var now := Time.get_unix_time_from_system()
	var sim_time = 0.0
	
	var acquired_items = {}
	
	while next_event and sim_time < now:
		sim_time = next_event.cat_assigned.next_available_time
		var acq_item = next_event.cat_assigned.chosen_item
		if acquired_items.get(acq_item):
			acquired_items[acq_item] += 1
		else:
			acquired_items[acq_item] = 1
		
		food_system.process_time(sim_time)
		next_event = _get_next_event()
	
	offline_display.display_items(acquired_items)
	
func _get_next_event() -> FoodBowlState:
	""" Retorna bowl cujo gato tem a chegada mais próxima """
	var next_event: FoodBowlState = null
	for bowl: FoodBowlState in FoodBowlManager.bowls:
		if bowl.cat_assigned:
			if next_event == null:
				next_event = bowl
			elif bowl.cat_assigned.next_available_time < next_event.cat_assigned.next_available_time:
				next_event = bowl
	return next_event
# --------------------------------------------------

func _craft_potion(selector: SelectionController) -> void:
	var items := selector.get_selected_items()
	var signature := SelectionNormalizer.make_signature(items)
	var potion := CreationRegistry.get_or_create(signature, items)
