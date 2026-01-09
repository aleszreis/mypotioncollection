extends Node

@onready var food_system: FoodAttractionSystem = $FoodAttractionSystem
@onready var bowl_manager: FoodBowlManager = $FoodBowlManager


func _ready() -> void:
	_spawn_initial_cats()
	#_DEBUG_spawn_inventory_items()
	_process_offline_progress()
	
	UserConfig.set_inventory_from_save()
	
	SignalBus.craft_pressed.connect(_craft_potion)

func _process(_delta: float) -> void:
	var now := Time.get_unix_time_from_system()
	food_system.process_time(now)

# --------------------------------------------------

func _spawn_initial_cats() -> void:
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
	var now := Time.get_unix_time_from_system()
	food_system.process_time(now)

# --------------------------------------------------

func _craft_potion(selector: SelectionController) -> void:
	var items := selector.get_selected_items()
	var signature := SelectionNormalizer.make_signature(items)
	var potion := CreationRegistry.get_or_create(signature, items)
