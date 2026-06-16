extends Label

enum Moves { ATTACK, BLOCK, THROW }

func display_move(move_index: int, is_player: bool):
    var move_name = ""
    match move_index:
        Moves.ATTACK: move_name = "ATTACK!"
        Moves.BLOCK: move_name = "BLOCK!"
        Moves.THROW: move_name = "THROW!"
    
    self.text = move_name
    self.modulate = Color(0.8, 0.8, 0.8, 1) # Default color
    if is_player: 
        self.modulate = Color(0.2, 0.6, 0.8, 1) # Player color
    else: 
        self.modulate = Color(0.8, 0.2, 0.2, 1) # Opponent color

    show()
    var tween = create_tween()
    tween.tween_property(self, "global_position", global_position + Vector2(0, -50), 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    tween.tween_property(self, "modulate:a", 0.0, 0.5).set_delay(0.5)
    tween.tween_callback(hide_and_reset)

func hide_and_reset():
    hide()
    self.modulate = Color(1, 1, 1, 1) # Reset modulate for next display
    self.position = Vector2(0,0) # Reset position

