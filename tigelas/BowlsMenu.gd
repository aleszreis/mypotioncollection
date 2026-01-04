extends VBoxContainer

@onready var bowls_ui_container = $BowlsContainer
@onready var food_selection = $"../../FoodOptionsMenu"
@onready var bowl_manager = $"../../Game/FoodBowlManager"

func _ready():
	for child in bowls_ui_container.get_children():
		child.pressed.connect(_on_bowl_button_pressed.bind(child))
	SignalBus.bowl_state_changed.connect(_on_bowl_state_changed)

func _on_bowl_button_pressed(bowl: TextureButton):
	var index = bowl.get_index()
	print("BowlsMenu.gd: Tigela %s selecionada" % index)
	bowl_manager.set_active_bowl(index)
	food_selection.open()

func _on_bowl_state_changed(bowl_index: int, food_icon: Resource = load("res://tigelas/sprites/empty.svg")):
	var bowl_button = bowls_ui_container.get_child(bowl_index)
	bowl_button.texture_normal = food_icon
