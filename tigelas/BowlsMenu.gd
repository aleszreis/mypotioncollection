extends VBoxContainer

@onready var food_selection = $"../../FoodOptionsMenu"
@onready var bowl_manager = $"../../Game/FoodBowlManager"

func _ready():
	for child in get_children():
		child.pressed.connect(_on_bowl_button_pressed.bind(child))
	SignalBus.bowl_state_changed.connect(_on_bowl_state_changed)

func _on_bowl_button_pressed(bowl: Button):
	var index = bowl.get_index()
	print("BowlsMenu.gd: Tigela %s selecionada" % index)
	bowl_manager.set_active_bowl(index)
	food_selection.open()

func _on_bowl_state_changed(bowl_index: int, food_icon: Resource = load("res://tigelas/sprites/empty.png")):
	var bowl_button = get_child(bowl_index)
	bowl_button.icon = food_icon
