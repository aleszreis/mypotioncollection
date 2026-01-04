extends Node

var inventory := Inventory
var ingredient_catalog := IngredientCatalog
@onready var food_system: FoodAttractionSystem = $FoodAttractionSystem
@onready var bowl_manager: FoodBowlManager = $FoodBowlManager


func _ready() -> void:
	_setup_system_links()
	_spawn_initial_cats()
	_create_debug_bowl()
	_process_offline_progress()

func _process(_delta: float) -> void:
	var now := Time.get_unix_time_from_system()
	food_system.process_time(now)

# --------------------------------------------------

func _setup_system_links() -> void:
	food_system.inventory = inventory
	food_system.ingredient_catalog = ingredient_catalog
	food_system.bowls = bowl_manager.bowls

# --------------------------------------------------

func _spawn_initial_cats() -> void:
	var all_cats_data = ImportItemData.cats_data.values()
	
	for cat in all_cats_data:
		var cat_instance := CatInstance.new()
		cat_instance.data = cat
		food_system.cats.append(cat_instance)

# --------------------------------------------------

func _create_debug_bowl() -> void:
	bowl_manager.add_bowl()
	bowl_manager.add_bowl()
	bowl_manager.add_bowl()
	bowl_manager.add_bowl()
	food_system.bowls = bowl_manager.bowls

# --------------------------------------------------

func _process_offline_progress() -> void:
	var now := Time.get_unix_time_from_system()
	food_system.process_time(now)
