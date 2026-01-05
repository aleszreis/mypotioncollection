extends Container
class_name RadialContainer

@export var button_radius: float = 80.0

func _ready():
	_build_food_options()
	close()

func open():
	visible = true
	set_process_input(true)

func close():
	visible = false
	set_process_input(false)
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		_sort_children()

func _sort_children() -> void:
	if size.x <= 0.0 or size.y <= 0.0:
		print("Nenhuma comida encontrada")
		return
	
	var children: Array[Control] = []
	for c in get_children():
		if c is Control:
			children.append(c)
	
	var count: int = children.size()
	if count == 0:
		return
	
	var center = get_viewport().get_mouse_position()
	#var center: Vector2 = size * 0.5
	var angle_step: float = TAU / (count - 1)
	var angle: float = -PI * 0.5
	
	for child: Control in children:
		var child_size: Vector2 = child.get_combined_minimum_size()
		
		if child == children[0]:
			fit_child_in_rect(child, Rect2(center, child_size))
			continue
		
		var offset: Vector2 = Vector2(button_radius, 0.0).rotated(angle)
		var pos: Vector2 = center + offset - child_size * 0.5
		fit_child_in_rect(child, Rect2(pos, child_size))
		
		var cos_angle: float = cos(angle)
		if abs(cos_angle) < 0.3:
			child.grow_horizontal = Control.GROW_DIRECTION_BOTH
		elif cos_angle < 0.0:
			child.grow_horizontal = Control.GROW_DIRECTION_BEGIN
		else:
			child.grow_horizontal = Control.GROW_DIRECTION_END
		
		angle += angle_step

func _build_food_options():
	for food in ImportItemData.foods_data.values():
		var food_button = TextureButton.new()
		food_button.texture_normal = food.icon
		food_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		food_button.custom_minimum_size = Vector2(48, 48)
		#food_button.autowrap_mode = TextServer.AUTOWRAP_WORD
		food_button.set_meta("associated_food", food)
		food_button.pressed.connect(_on_food_button_pressed.bind(food_button))
		add_child(food_button)
		#var food_label = Label.new()
		#food_label.text = food.display_name
		#food_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		#food_label.vertical_alignment = HORIZONTAL_ALIGNMENT_CENTER
		#food_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		#add_child(food_label)

func _on_food_button_pressed(button: TextureButton):
	var food = button.get_meta("associated_food")
	
	SignalBus.fill_bowl.emit(food)
	close()


func _on_close_button_pressed() -> void:
	close()
