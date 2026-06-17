extends Button

func _ready():
    hide() # Start hidden
    GameManager.connect("show_super_button", Callable(self, "show"))
    GameManager.connect("hide_reset_button", Callable(self, "hide")) # Hide super button when reset (which also hides the reset button)

func _on_pressed():
    if GameManager.current_state == GameManager.GameState.GAME_OVER and GameManager.time_left <= 0:
        GameManager._on_player_uses_super()
        hide()
