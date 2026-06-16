extends Control

signal player_action_chosen(action_index)

enum Moves { ATTACK, BLOCK, THROW }

@onready var attack_button = $"HBoxContainer/AttackButton"
@onready var block_button = $"HBoxContainer/BlockButton"
@onready var throw_button = $"HBoxContainer/ThrowButton"

func _ready():
    set_buttons_enabled(true)

func _on_attack_button_pressed():
    player_action_chosen.emit(Moves.ATTACK)

func _on_block_button_pressed():
    player_action_chosen.emit(Moves.BLOCK)

func _on_throw_button_pressed():
    player_action_chosen.emit(Moves.THROW)

func set_buttons_enabled(enabled: bool):
    attack_button.disabled = not enabled
    block_button.disabled = not enabled
    throw_button.disabled = not enabled
