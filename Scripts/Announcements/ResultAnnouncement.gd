extends Label

func display_result(result_text: String):
    self.text = result_text
    show()
    var tween = create_tween()
    tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2).set_delay(1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
    tween.tween_callback(hide)

func hide_result():
    hide()
