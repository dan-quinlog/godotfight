extends Label

func display_enemy_super():
    show()
    var tween = create_tween()
    tween.set_loops(2)
    tween.tween_property(self, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    tween.tween_property(self, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
    tween.tween_callback(hide_and_reset)

func hide_and_reset():
    hide()
    self.modulate = Color(1, 1, 1, 1) # Reset modulate for next display
