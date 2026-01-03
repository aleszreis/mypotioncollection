extends Control

@onready var food_grid = $Panel/CenterContainer/FoodList
@onready var bowl_manager = $"../Game/FoodBowlManager"

func _ready():
	_build_food_options()
	close()

func open():
	visible = true
	set_process_input(true)

func close():
	visible = false
	set_process_input(false)

func _build_food_options():
	for food in ImportItemData.foods_data.values():
		var food_column = VBoxContainer.new()
		food_grid.add_child(food_column)
		var food_button = Button.new()
		food_button.icon = food.icon
		food_button.autowrap_mode = TextServer.AUTOWRAP_WORD
		food_button.set_meta("associated_food", food)
		food_button.pressed.connect(_on_food_button_pressed.bind(food_button))
		food_column.add_child(food_button)
		var food_label = Label.new()
		food_label.text = food.display_name
		food_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		food_label.vertical_alignment = HORIZONTAL_ALIGNMENT_CENTER
		food_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		food_column.add_child(food_label)

func _on_food_button_pressed(button: Button):
	var food = button.get_meta("associated_food")
	
	bowl_manager.fill_bowl(food)
	close()
