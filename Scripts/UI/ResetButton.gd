extends Button

signal reset_game

func _on_pressed():
    reset_game.emit()
