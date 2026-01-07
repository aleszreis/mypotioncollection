extends VBoxContainer

@onready var food_selection = $"../../../FoodOptionsMenu"
@onready var bowl_manager: FoodBowlManager = $"../../../Game/FoodBowlManager"

var empty_bowl_icon = load("res://bowls/sprites/empty.png")

func _ready():
	_create_bowl_btns()
	
	for child in get_children():
		child.pressed.connect(_on_bowl_button_pressed.bind(child))
	SignalBus.update_bowl_button.connect(_on_bowl_state_changed)

func _create_bowl_btns() -> void:
	for bowl: FoodBowlState in bowl_manager.bowls:
		var bowl_btn = TextureButton.new()
		_update_bowl_icon(bowl, bowl_btn)
		bowl_btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		add_child(bowl_btn)

func _on_bowl_button_pressed(bowl: TextureButton):
	var index = bowl.get_index()
	print("BowlsMenu.gd: Tigela %s selecionada" % index)
	bowl_manager.set_active_bowl(index)
	food_selection.open()

func _on_bowl_state_changed(bowl_index: int):
	var bowl_button = get_child(bowl_index)
	var bowl_info = bowl_manager.bowls[bowl_index]
	_update_bowl_icon(bowl_info, bowl_button)

func _update_bowl_icon(bowl: FoodBowlState, btn: TextureButton) -> void:
	if bowl.food_type:
		var food_icon = Db.get_food(bowl.food_type).icon 
		btn.texture_normal = food_icon
	else:
		btn.texture_normal = empty_bowl_icon
