extends Control

@onready var strikes_label = $"StrikesLabel"

func update_strikes(current_strikes: int, max_strikes: int):
    strikes_label.text = "Strikes: %d / %d" % [current_strikes, max_strikes]

func _ready():
    # Ensure it displays initial strikes when ready
    update_strikes(GameManager.current_strikes, GameManager.max_strikes)
