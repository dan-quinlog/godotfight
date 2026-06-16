extends Label

func display_strike():
    show()
    var tween = create_tween()
    tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1).set_delay(0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
    tween.tween_property(self, "modulate:a", 0.0, 0.5).set_delay(0.5)
    tween.tween_callback(hide_and_reset)

func hide_and_reset():
    hide()
    self.modulate = Color(1, 1, 1, 1) # Reset modulate for next display
    self.scale = Vector2(1,1) # Reset scale
