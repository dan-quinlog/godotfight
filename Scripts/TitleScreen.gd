extends Control

func _ready():
    # Ensure GameManager is ready when TitleScreen loads
    if GameManager.current_state != GameManager.GameState.TITLE:
        GameManager.current_state = GameManager.GameState.TITLE

func _on_start_button_pressed():
    GameManager.start_game()
