extends Node2D

const Collision_mask_card=1
const collision_mask_card_slot = 2
const card_speed = 0.1



var input_manager_reference
var card_drag
var screen_size
var is_hovering_on_card
var player_hand_reference

func _ready() -> void:
	screen_size = get_viewport_rect().size
	input_manager_reference = $"../InputManager"
	player_hand_reference = $"../PlayerHand"
	input_manager_reference.connect("release",on_left_click_released)
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card_drag:
		var mouse_pos = get_global_mouse_position()
		card_drag.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x),
			clamp(mouse_pos.y,0,screen_size.y))


func start_drag(card):
	card_drag = card
	card_drag.scale=Vector2(1,1)


func finish_drag():
	print("Running")
	card_drag.scale=Vector2(1.05,1.05)
	var card_slot_found = check_for_card_slot()
	if card_slot_found and not card_slot_found.card_in_slot:
		player_hand_reference.remove_card_from_hand(card_drag)
		#card dropped
		card_drag.position = card_slot_found.position
		card_drag.get_node("Area2D/CollisionShape2D").disabled=true
		card_slot_found.card_in_slot = true
	else:
		player_hand_reference.add_card_to_hand(card_drag, card_speed)
	card_drag=null


func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)

func on_left_click_released():
	if card_drag:
		finish_drag()
	


func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card,true)

func on_hovered_off_card(card):
	if !card_drag:
		#is_hovering_on_card = false
		highlight_card(card,false)
		var new_card_hovered = check_for_card()
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false

func highlight_card(card, hovered):
	if hovered:
		#Makes Card bigger
		card.scale=Vector2(1.05,1.05)
		card.z_index=2
	else:
		card.scale=Vector2(1,1)
		card.z_index=1


func check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = collision_mask_card_slot
	var result = space_state.intersect_point(parameters)
	if result.size()>0:	
		return result[0].collider.get_parent()
	return null
	
	
func check_for_card():
	var space_state= get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = Collision_mask_card
	var result = space_state.intersect_point(parameters)
	if result.size()>0:	
		return result[0].collider.get_parent()
		return get_card_with_highest_z_index(result)
	return null


func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].get_parent()
	var highest_z_index = highest_z_card.index
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
