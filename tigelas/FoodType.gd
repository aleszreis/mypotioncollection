# Determina as comidas que serão usadas nas tigelas
class_name FoodType
extends Resource

@export var id: String
@export var display_name: String
@export var icon: Texture2D = load("res://gatos/sprites/racao.png")
@export var fill_value: int
