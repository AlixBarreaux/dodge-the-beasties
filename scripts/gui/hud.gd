extends CanvasLayer


############################### DECLARE VARIABLES ##############################


# Node References
onready var message_panel: Panel = $MessagePanel
onready var message_label: Label = message_panel.get_node("MessageLabel")
onready var score_label: Label = $ScoreLabel
onready var high_score_label: RichTextLabel = $HighScoreLabel
onready var game_over_menu: Control = $GameOverMenu
onready var message_timer: Timer = $MessageTimer
onready var main_menu: Control = $MainMenu
onready var play_button: Button = main_menu.get_node("VBoxContainer/PlayButton")
onready var credits_button: Button = main_menu.get_node("VBoxContainer/CreditsButton")
onready var quit_to_desktop_button: Button = main_menu.get_node("VBoxContainer/QuitToDesktopButton")
onready var animation_player: AnimationPlayer = $AnimationPlayer


################################# RUN THE CODE #################################


func _ready() -> void:
	self._initialize_signals()
	self._initialize()
	return


############################### DECLARE FUNCTIONS ##############################


func _initialize_signals() -> void:
	Events.connect("main_menu_requested", self, "on_main_menu_requested")
	Events.connect("player_defeated", self, "on_player_defeated")
	return


func _initialize() -> void:
	game_over_menu.hide()
	return


func on_main_menu_requested() -> void:
	message_panel.hide()
	return


func update_score(score: int) -> void:
	score_label.text = "Score:  " + str(score)
	return


func update_high_score(high_score: int) -> void:
	high_score_label.bbcode_text = "[center]High score:  " + str(high_score) + "[/center]"
	return


func show_message(message: String) -> void:
	message_label.text = message
	message_panel.show()
	return


func show_message_with_timer(message: String) -> void:
	show_message(message)
	message_timer.start()
	return


func on_player_defeated() -> void:
	show_game_over()
	animation_player.play("Game Over")
	return


func show_game_over() -> void:
	game_over_menu.show()
	show_message("Game Over!")
	message_panel.show()
	return


func _on_PlayButton_pressed() -> void:
	main_menu.hide()
	Events.emit_signal("game_started")
	return


func _on_MessageTimer_timeout() -> void:
	message_panel.hide()
	return
