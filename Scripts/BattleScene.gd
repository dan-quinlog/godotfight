extends Node2D

@onready var player_character_scene = preload("res://Scenes/Characters/Player/Player.tscn")
@onready var opponent_character_scene = preload("res://Scenes/Characters/Opponent/Opponent.tscn")
@onready var action_buttons_scene = preload("res://Scenes/UI/ActionButtons.tscn")
@onready var reset_button_scene = preload("res://Scenes/UI/ResetButton.tscn")
@onready var move_announcement_scene = preload("res://Scenes/Announcements/MoveAnnouncement.tscn")
@onready var result_announcement_scene = preload("res://Scenes/Announcements/ResultAnnouncement.tscn")
@onready var strike_announcement_scene = preload("res://Scenes/Announcements/StrikeAnnouncement.tscn") # New strike announcement
@onready var enemy_super_announcement_scene = preload("res://Scenes/Announcements/EnemySuperAnnouncement.tscn") # New Enemy Super announcement
@onready var timer_ui_scene = preload("res://Scenes/UI/TimerUI.tscn") # New Timer UI
@onready var strike_counter_ui_scene = preload("res://Scenes/UI/StrikeCounterUI.tscn") # New Strike Counter UI

var player_node
var opponent_node
var action_buttons_node
var reset_button_node
var player_move_announcement_node
var opponent_move_announcement_node
var result_announcement_node
var strike_announcement_node
var enemy_super_announcement_node
var timer_ui_node
var strike_counter_ui_node

func _ready():
    # The BattleScene will now be instantiated by GameManager.gd
    # and GameManager will call a setup method on it.
    pass

func setup_battle_scene():
    # Clear existing nodes if resetting
    for child in get_children():
        child.queue_free()

    # Instance Player
    player_node = player_character_scene.instantiate()
    player_node.position = Vector2(200, 400) # Placeholder position
    add_child(player_node)

    # Instance Opponent
    opponent_node = opponent_character_scene.instantiate()
    opponent_node.position = Vector2(900, 400) # Placeholder position
    add_child(opponent_node)

    # Instance Action Buttons
    action_buttons_node = action_buttons_scene.instantiate()
    action_buttons_node.position = Vector2(get_viewport_rect().size.x / 2 - 200, get_viewport_rect().size.y - 100) # Centered at bottom, larger spread
    add_child(action_buttons_node)
    action_buttons_node.connect("player_action_chosen", GameManager._on_player_action_chosen)

    # Instance Move Announcements (initially hidden)
    player_move_announcement_node = move_announcement_scene.instantiate()
    player_move_announcement_node.position = Vector2(player_node.position.x, player_node.position.y - 200)
    add_child(player_move_announcement_node)
    player_move_announcement_node.hide()

    opponent_move_announcement_node = move_announcement_scene.instantiate()
    opponent_move_announcement_node.position = Vector2(get_viewport_rect().size.x / 2, opponent_node.position.y - 200) # Centered for opponent
    add_child(opponent_move_announcement_node)
    opponent_move_announcement_node.hide()

    # Instance Result Announcement (initially hidden)
    result_announcement_node = result_announcement_scene.instantiate()
    result_announcement_node.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
    add_child(result_announcement_node)
    result_announcement_node.hide()

    # Instance Strike Announcement (initially hidden)
    strike_announcement_node = strike_announcement_scene.instantiate()
    strike_announcement_node.position = Vector2(player_node.position.x, player_node.position.y - 200)
    add_child(strike_announcement_node)
    strike_announcement_node.hide()

    # Instance Enemy Super Announcement (initially hidden)
    enemy_super_announcement_node = enemy_super_announcement_scene.instantiate()
    enemy_super_announcement_node.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
    add_child(enemy_super_announcement_node)
    enemy_super_announcement_node.hide()

    # Instance Timer UI
    timer_ui_node = timer_ui_scene.instantiate()
    timer_ui_node.position = Vector2(get_viewport_rect().size.x / 2, 50)
    add_child(timer_ui_node)
    
    # Instance Strike Counter UI
    strike_counter_ui_node = strike_counter_ui_scene.instantiate()
    strike_counter_ui_node.position = Vector2(100, 50)
    add_child(strike_counter_ui_node)

    # Hide reset button at start
    if reset_button_node: # Clear old one if exists
        reset_button_node.queue_free()
    reset_button_node = reset_button_scene.instantiate()
    reset_button_node.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y - 50)
    add_child(reset_button_node)
    reset_button_node.connect("reset_game", GameManager._on_reset_game_requested)
    reset_button_node.hide()

    GameManager.connect("display_player_move", Callable(player_move_announcement_node, "display_move"))
    GameManager.connect("display_opponent_move", Callable(opponent_move_announcement_node, "display_move"))
    GameManager.connect("display_result", Callable(result_announcement_node, "display_result"))
    GameManager.connect("display_strike", Callable(strike_announcement_node, "display_strike"))
    GameManager.connect("display_enemy_super", Callable(enemy_super_announcement_node, "display_enemy_super"))
    GameManager.connect("set_action_buttons_enabled", Callable(action_buttons_node, "set_buttons_enabled"))
    GameManager.connect("update_timer_display", Callable(timer_ui_node, "update_timer"))
    GameManager.connect("update_strike_counter", Callable(strike_counter_ui_node, "update_strikes"))
    GameManager.connect("show_reset_button", Callable(reset_button_node, "show"))
    GameManager.connect("hide_reset_button", Callable(reset_button_node, "hide"))
    
    # Ensure action buttons are enabled at the start of a battle round
    action_buttons_node.set_buttons_enabled(true)


func _on_player_action_chosen(player_move_index):
    # This will now be handled by GameManager
    pass

func determine_winner(player_move, opponent_move):
    # This will now be handled by GameManager
    return 0

func show_reset_button():
    # This will now be handled by GameManager
    pass

func _on_reset_game():
    # This will now be handled by GameManager
    pass

func setup_game():
    # Clear existing nodes if resetting
    for child in get_children():
        child.queue_free()

    # Instance Player
    player_node = player_character.instantiate()
    player_node.position = Vector2(200, 400) # Placeholder position
    add_child(player_node)

    # Instance Opponent
    opponent_node = opponent_character.instantiate()
    opponent_node.position = Vector2(900, 400) # Placeholder position
    add_child(opponent_node)

    # Instance Action Buttons
    action_buttons_node = action_buttons.instantiate()
    action_buttons_node.position = Vector2(get_viewport_rect().size.x / 2 - 150, get_viewport_rect().size.y - 100) # Centered at bottom
    add_child(action_buttons_node)
    action_buttons_node.connect("player_action_chosen", _on_player_action_chosen)

    # Instance Move Announcements (initially hidden)
    player_move_announcement_node = move_announcement.instantiate()
    player_move_announcement_node.position = Vector2(player_node.position.x, player_node.position.y - 100)
    add_child(player_move_announcement_node)
    player_move_announcement_node.hide()

    opponent_move_announcement_node = move_announcement.instantiate()
    opponent_move_announcement_node.position = Vector2(opponent_node.position.x, opponent_node.position.y - 100)
    add_child(opponent_move_announcement_node)
    opponent_move_announcement_node.hide()

    # Instance Result Announcement (initially hidden)
    result_announcement_node = result_announcement.instantiate()
    result_announcement_node.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
    add_child(result_announcement_node)
    result_announcement_node.hide()

    # Hide reset button at start
    # reset_button_node is instantiated later if needed

func _on_player_action_chosen(player_move_index):
    # Disable action buttons during interaction
    action_buttons_node.set_buttons_enabled(false)

    var opponent_move_index = randi() % 3 # 0: Attack, 1: Block, 2: Throw (random for now)

    # Display player and opponent moves
    player_move_announcement_node.display_move(player_move_index, true)
    opponent_move_announcement_node.display_move(opponent_move_index, false)

    var result = determine_winner(player_move_index, opponent_move_index)
    var result_text = ""

    match result:
        0: result_text = "TIE!"
        1: result_text = "WINNER!"
        -1: result_text = "LOSER!"

    result_announcement_node.display_result(result_text)

    # Show reset button after a delay
    get_tree().create_timer(2.0).timeout.connect(show_reset_button) # Wait 2 seconds before showing reset button

func determine_winner(player_move, opponent_move):
    # 0: Attack, 1: Block, 2: Throw
    # Attack (0) beats Throw (2)
    # Block (1) beats Attack (0)
    # Throw (2) beats Block (1)

    if player_move == opponent_move:
        return 0 # Tie

    if (player_move == 0 and opponent_move == 2) or \
       (player_move == 1 and opponent_move == 0) or \
       (player_move == 2 and opponent_move == 1):
        return 1 # Player wins
    else:
        return -1 # Player loses

func show_reset_button():
    if not reset_button_node:
        reset_button_node = reset_button.instantiate()
        reset_button_node.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y - 50)
        add_child(reset_button_node)
        reset_button_node.connect("reset_game", setup_game)
    reset_button_node.show()


func _on_reset_game():
    setup_game()

