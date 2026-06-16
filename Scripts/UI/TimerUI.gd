extends Control

@onready var timer_label = $"HBoxContainer/TimerLabel"
@onready var heartbeat_bar = $"HBoxContainer/HeartbeatBar"
@onready var blip = $"HBoxContainer/HeartbeatBar/Blip"

var heartbeat_tween: Tween

func _ready():
    blip.hide()

func update_timer(time_left: float):
    timer_label.text = "Time Left: %0.1fs" % max(0, time_left)

    # Start/reset blip animation only if the game is playing
    if GameManager.current_state == GameManager.GameState.PLAYING:
        var ai_interval = 0.0
        if GameManager.total_game_time - time_left < GameManager.ai_move_delay_threshold:
            ai_interval = 1.0
        else:
            ai_interval = 0.5

        if not heartbeat_tween or not heartbeat_tween.is_running():
            start_blip_animation(ai_interval)

func start_blip_animation(duration: float):
    if heartbeat_tween and heartbeat_tween.is_running():
        heartbeat_tween.kill()
    
    blip.show()
    var bar_width = heartbeat_bar.size.x
    blip.position = Vector2(bar_width - blip.size.x, blip.position.y) # Start blip on the right

    heartbeat_tween = create_tween()
    heartbeat_tween.tween_property(blip, "position:x", 0, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
    heartbeat_tween.tween_callback(on_blip_animation_complete)

func on_blip_animation_complete():
    blip.hide()
    # GameManager will handle re-triggering AI move and new blip animation if needed
