extends Node

signal craft_pressed(selector)

signal change_ui_ingredient(item)

signal ingredient_acquired(ingredient_id, value)
signal potion_acquired(potion)
signal ingredient_consumed(ingredient_id, value, use)

signal cat_scheduled(bowl)

signal open_food_menu()

signal set_active_bowl(bowl)
signal bowl_state_changed(index, icon)
signal change_bowl_food(food)
signal remove_food(bowl, amount)
signal update_bowl_button()
