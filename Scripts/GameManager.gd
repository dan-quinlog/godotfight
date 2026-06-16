extends Node

signal game_started
signal game_over(result: String) # "WIN" or "LOSE"
signal display_player_move(move_index: int, is_player: bool)
signal display_opponent_move(move_index: int, is_player: bool)
signal display_result(result_text: String)
signal display_strike()
signal display_enemy_super()
signal update_timer_display(time_left: float)
signal update_strike_counter(current_strikes: int, max_strikes: int)
signal set_action_buttons_enabled(enabled: bool)
signal show_reset_button()
signal hide_reset_button()
signal show_super_button()

enum GameState { TITLE, PLAYING, GAME_OVER, VICTORY }
enum Moves { ATTACK, BLOCK, THROW }

var current_state: GameState = GameState.TITLE
var current_strikes: int = 0
var max_strikes: int = 3
var time_left: float = 0.0
var total_game_time: float = 10.0
var ai_move_interval: float = 1.0
var ai_move_delay_threshold: float = 5.0 # After 5 seconds, AI moves faster

var player_move: int = -1 # -1 means no move chosen yet
var opponent_move: int = -1
var can_player_input: bool = true

var battle_scene = preload("res://Scenes/BattleScene.tscn")

func _ready():
    set_process(false) # Start with process disabled, enabled when playing

func _process(delta: float):
    if current_state != GameState.PLAYING:
        return

    time_left -= delta
    update_timer_display.emit(time_left)

    if time_left <= 0:
        end_game_by_time()
        return

    # Handle AI move timing
    var next_ai_move_interval = 0.0
    if total_game_time - time_left < ai_move_delay_threshold:
        next_ai_move_interval = 1.0 # First 5 seconds, AI moves every 1 second
    else:
        next_ai_move_interval = 0.5 # Last 5 seconds, AI moves every 0.5 seconds

    if get_tree().get_nodes_in_group("ai_timer").is_empty():
        var timer = Timer.new()
        timer.wait_time = next_ai_move_interval
        timer.one_shot = true
        timer.autostart = true
        timer.name = "ai_move_timer"
        timer.add_to_group("ai_timer")
        add_child(timer)
        timer.connect("timeout", _on_ai_move_timer_timeout)

func start_game():
    current_state = GameState.PLAYING
    current_strikes = 0
    time_left = total_game_time
    player_move = -1
    opponent_move = -1
    can_player_input = true
    set_process(true)
    set_action_buttons_enabled.emit(true)
    hide_reset_button.emit()
    update_strike_counter.emit(current_strikes, max_strikes)

    # Load and setup Battle Scene
    if get_tree().current_scene != battle_scene.instantiate(): # Check if already in battle scene
        get_tree().change_scene_to_packed(battle_scene)
        await get_tree().process_frame
        # Call setup on the new battle scene after it's ready
        if get_tree().current_scene and get_tree().current_scene.has_method("setup_battle_scene"):
            get_tree().current_scene.setup_battle_scene()
    else:
        # If already in battle scene (e.g., after a reset from game over), just re-setup
        if get_tree().current_scene and get_tree().current_scene.has_method("setup_battle_scene"):
            get_tree().current_scene.setup_battle_scene()

    game_started.emit()

func _on_player_action_chosen(p_move_index: int):
    if not can_player_input or current_state != GameState.PLAYING:
        return

    player_move = p_move_index
    set_action_buttons_enabled.emit(false) # Disable buttons until next AI move
    display_player_move.emit(player_move, true)

    # If player inputs correctly, counter the AI's *last* move (if any)
    if opponent_move != -1:
        var result = determine_winner(player_move, opponent_move)
        if result == 1: # Player wins the interaction
            display_result.emit("GREAT COUNTER!")
            # Reset for next round
            opponent_move = -1
            can_player_input = true
            set_action_buttons_enabled.emit(true)
        else: # Player loses the interaction (or ties)
            take_strike()
    else:
        # If player inputs before AI makes a move for this round, it's a strike
        take_strike()
    
    # Cancel the AI timer to reset for the next AI move or if player input was valid
    for timer in get_tree().get_nodes_in_group("ai_timer"):
        timer.queue_free()

func _on_ai_move_timer_timeout():
    if current_state != GameState.PLAYING:
        return

    # If player didn't input a move, or input incorrectly for the previous AI move,
    # and the timer runs out, it's a strike.
    if player_move == -1 or determine_winner(player_move, opponent_move) != 1:
        take_strike()

    # AI makes a new random move
    opponent_move = randi() % 3
    display_opponent_move.emit(opponent_move, false)

    # Reset player's input state for the new AI move
    player_move = -1
    can_player_input = true
    set_action_buttons_enabled.emit(true)

func determine_winner(p_move: int, o_move: int) -> int:
    # 0: Attack, 1: Block, 2: Throw
    # Attack (0) beats Throw (2)
    # Block (1) beats Attack (0)
    # Throw (2) beats Block (1)

    if p_move == o_move:
        return 0 # Tie (currently treated as a loss for the player in the new mechanics)

    if (p_move == Moves.ATTACK and o_move == Moves.THROW) or \
       (p_move == Moves.BLOCK and o_move == Moves.ATTACK) or \
       (p_move == Moves.THROW and o_move == Moves.BLOCK):
        return 1 # Player wins
    else:
        return -1 # Player loses

func take_strike():
    current_strikes += 1
    display_strike.emit()
    update_strike_counter.emit(current_strikes, max_strikes)
    if current_strikes >= max_strikes:
        end_game_by_strikes()

func end_game_by_time():
    current_state = GameState.GAME_OVER
    set_process(false)
    set_action_buttons_enabled.emit(false)
    # Player survived 10 seconds, show SUPER button
    show_super_button.emit()
    show_reset_button.emit() # Also show reset if they won by time

func end_game_by_strikes():
    current_state = GameState.GAME_OVER
    set_process(false)
    set_action_buttons_enabled.emit(false)
    display_enemy_super.emit() # Player lost all strikes, Enemy Super! animation
    show_reset_button.emit()

func _on_player_uses_super():
    if current_state == GameState.GAME_OVER and time_left <= 0:
        current_state = GameState.VICTORY
        set_action_buttons_enabled.emit(false)
        display_result.emit("PLAYER VICTORY!")
        show_reset_button.emit()

func _on_reset_game_requested():
    # This is called by the ResetButton, or from GameManager itself
    current_state = GameState.TITLE # Go back to title or restart game directly
    set_process(false)
    set_action_buttons_enabled.emit(false)
    hide_reset_button.emit()
    # For this test, let's go directly to starting game again for now, without going to title screen
    # In a full game, you'd change_scene_to_packed(title_screen_scene)
    start_game()
