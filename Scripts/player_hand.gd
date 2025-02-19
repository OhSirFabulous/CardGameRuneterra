extends Node2D

const CARD_WIDTH = 200
const hand_y_position = 890
const card_speed = 0.1

var player_hand = []
var center_screen_x
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
	


func add_card_to_hand(card, speed):
	if card not in player_hand:
		player_hand.insert(0,card)
		update_hand_positions(speed)
	else: 
		animate_card_to_position(card, card.starting_position,speed)

func update_hand_positions(speed):
	for i in range(player_hand.size()):
		var new_position = Vector2(calculate_card_position(i), hand_y_position)
		var card = player_hand[i]
		card.starting_position = new_position
		animate_card_to_position(card, new_position, card_speed)

func calculate_card_position(index):
	var total_width = (player_hand.size() -1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func animate_card_to_position(card, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)

func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions(card_speed)
