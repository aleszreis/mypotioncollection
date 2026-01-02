extends VBoxContainer

@onready var food_selection = $"../../FoodOptionsMenu"
@onready var bowl_manager = $"../../Game/FoodBowlManager"

func _ready():
	for child in get_children():
		child.pressed.connect(_on_bowl_button_pressed.bind(child))

func _on_bowl_button_pressed(bowl: Button):
	var index = bowl.get_index()
	print("BowlsMenu.gd: Tigela %s selecionada" % index)
	bowl_manager.set_active_bowl(index)
	food_selection.open()
