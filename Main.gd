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
	food_system.cats = UserConfig.set_cats_from_save()

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
		sim_time = next_event.next_available_time
		var acq_item = next_event.chosen_item
		if acquired_items.get(acq_item):
			acquired_items[acq_item] += 1
		else:
			acquired_items[acq_item] = 1
		
		food_system.process_time(sim_time)
		next_event = _get_next_event()
	
	offline_display.display_items(acquired_items)
	
func _get_next_event() -> CatInstance:
	""" Retorna gato com a chegada mais próxima """
	var next_event: CatInstance = null
	for cat: CatInstance in food_system.cats:
		if cat.is_busy:
			if next_event == null:
				next_event = cat
			elif cat.next_available_time < next_event.next_available_time:
				next_event = cat
	return next_event
# --------------------------------------------------

func _craft_potion(selector: SelectionController) -> void:
	var items := selector.get_selected_items()
	var signature := SelectionNormalizer.make_signature(items)
	var potion := CreationRegistry.get_or_create(signature, items)
