class_name BowlButton
extends Button

var bowl_id: int

var EMPTY_BOWL_ICON = load("res://bowls/sprites/empty.png")

func _ready():
	_update_bowl_button()
	
	pressed.connect(_on_bowl_button_pressed)
	SignalBus.update_bowl_button.connect(_update_bowl_button)

func _on_bowl_button_pressed():
	SignalBus.set_active_bowl.emit(bowl_id)
	SignalBus.open_food_menu.emit()
	
func _update_bowl_button() -> void:
	var bowl = FoodBowlManager.bowls[bowl_id]
	if not bowl.food_type or bowl.remaining_amount <= 0:
		icon = EMPTY_BOWL_ICON
	else:
		var food = FoodDatabase.get_by_id(bowl.food_type)
		icon = food.icon
