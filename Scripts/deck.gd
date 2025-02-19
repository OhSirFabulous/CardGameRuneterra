extends Node2D

const card_scene_path = "res://Cards/Card.tscn"
const card_draw_speed =  0.2

var player_deck = ["knight", "knight", "knight"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.text = str(player_deck.size()) # Replace with function body.


func draw_card():
	var card_drawn = player_deck[0]
	player_deck.erase(card_drawn)
	
	if player_deck.size()==0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visiable = false
		$RichTextLabel.visible = false
	
	$RichTextLabel.text = str(player_deck.size())
	var card_scene = preload(card_scene_path)
	var new_card = card_scene.instantiate()
	$"../Card Manager".add_child(new_card)
	new_card.name = "Card"
	$"../PlayerHand".add_card_to_hand(new_card, card_draw_speed)
