extends Node2D

const Collision_mask=1

var card_drag
var screen_size
var is_hovering_on_card


func _ready() -> void:
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card_drag:
		var mouse_pos = get_global_mouse_position()
		card_drag.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x),
			clamp(mouse_pos.y,0,screen_size.y))
# Called when the node enters the scene tree for the first time.
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = check_for_card()
			if card:
				start_drag(card)
		else:
			if card_drag:
				finish_drag()

func start_drag(card):
	card_drag = card
	card_drag.scale=Vector2(1,1)

func finish_drag():
	card_drag.scale=Vector2(1.05,1.05)
	card_drag=null



func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)

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

func check_for_card():
	var space_state= get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
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
