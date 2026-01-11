class_name ProceduralItemGenerator
extends Node

var FLASK_FOLDER_PATH = "res://potions/sprites/flasks/"
var LIQUID_FOLDER_PATH = "res://potions/sprites/liquids/"

func generate_item(signature: String, potion_name: String, ingredients: Array[IngredientData]) -> PotionData:
	var rng := RandomNumberGenerator.new()
	rng.seed = signature.hash()
	
	var item := PotionData.new()
	item.signature = signature
	item.rarity = _calculate_rarity(ingredients)
	
	# PLACEHOLDERS — regras específicas entram depois
	item.display_name = potion_name
	item.icon = _generate_icon(ingredients, rng)
	
	return item

func _calculate_rarity(items: Array[IngredientData]) -> int:
	var avg_rarity = 0
	for ingredient in items:
		avg_rarity += ingredient.rarity
	return floor(avg_rarity / items.size())

# ------------ SPRITE BUILDER

func _generate_icon(items: Array[IngredientData], rng) -> Texture2D:
	# Selecione um frasco e líquido aleatórios
	var flask_path = _pick_random_flask(rng)
	var liquid_image = _load_image(_pick_liquid(flask_path))
	
	# Transforme ingredientes em cores
	var main_colors: Array[Color] = []
	for ingredient in items:
		var img_path = ingredient.icon.resource_path
		var img = _load_image(img_path)
		
		main_colors.append(_get_dominant_color(img))
	
	# Pinte o líquido
	var mixed_colors = _blend_colors(main_colors)
	var tinted_liquid = _tint_liquid(liquid_image, mixed_colors)
	
	# Sobreponha o frasco
	var flask_image = _load_image(flask_path)
	var final_flask = _merge_flask_and_liquid(tinted_liquid, flask_image)
	
	return ImageTexture.create_from_image(final_flask)

func _load_image(path: String) -> Image:
	var img := Image.new()
	img.load(path)
	img.convert(Image.FORMAT_RGBA8)
	return img

func _get_images_from_folder(path: String) -> Array[String]:
	var files: Array[String] = []
	var dir := DirAccess.open(path)
	if dir == null:
		push_error("Não foi possível abrir: " + path)
		return files

	dir.list_dir_begin()
	var file_name := dir.get_next()

	while file_name != "":
		if not dir.current_is_dir():
			if file_name.get_extension().to_lower() in ["png", "jpg", "webp"]:
				files.append(path + "/" + file_name)
		file_name = dir.get_next()

	dir.list_dir_end()
	return files

func _pick_random_flask(rng) -> String:
	var files := _get_images_from_folder(FLASK_FOLDER_PATH)
	if files.is_empty():
		push_error("Pasta vazia: " + FLASK_FOLDER_PATH)
		return ""
	return files[rng.randi_range(0, files.size() - 1)]

func _pick_liquid(flask_path: String) -> String:
	return flask_path.replace('flask', 'liquid')

func _get_dominant_color(ingredient_sprite: Image) -> Color:
	var color_count := {}
	
	for y in ingredient_sprite.get_height():
		for x in ingredient_sprite.get_width():
			var c := ingredient_sprite.get_pixel(x, y)
			if c.a < 0.2:
				continue
				
			var key := Color(
				c.r,
				c.g,
				c.b,
				1.0
			)
			
			color_count[key] = color_count.get(key, 0) + 1
	
	var dominant_color := Color.WHITE
	var max_count := 0
	
	for k in color_count:
		if color_count[k] > max_count:
			max_count = color_count[k]
			dominant_color = k
			
	return dominant_color

func _blend_colors(colors: Array[Color]) -> Color:
	var h := 0.0
	var s := 0.0
	var v := 0.0

	for c in colors:
		h += c.h
		s += c.s
		v += c.v

	var n := colors.size()
	return Color.from_hsv(
		h / n,
		clamp(s / n, 0.6, 1.0),
		clamp(v / n, 0.7, 1.0),
		1.0
	)

func _tint_liquid(base_liquid: Image, target_color: Color, strenght: float = 0.95) -> Image:
	var tinted_liquid := base_liquid.duplicate()
	
	for y in tinted_liquid.get_height():
		for x in tinted_liquid.get_width():
			var c = tinted_liquid.get_pixel(x, y)
			if c.a < 0.2:
				continue
				
			var tinted_pixel = c.lerp(target_color, strenght)
			tinted_pixel.a = c.a
			tinted_liquid.set_pixel(x, y, tinted_pixel)
	
	return tinted_liquid
	
func _merge_flask_and_liquid(liquid: Image, flask: Image) -> Image:
	var result = liquid.duplicate()
	
	for y in result.get_height():
		for x in result.get_width():
			var top := flask.get_pixel(x, y)
			if top.a > 0.0:
				result.set_pixel(x, y, top)
	return result
