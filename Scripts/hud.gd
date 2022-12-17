extends CanvasLayer


############################### DECLARE VARIABLES ##############################


# Node References
onready var message_panel: Panel = $MessagePanel
onready var message_label: Label = message_panel.get_node("MessageLabel")
onready var score_label: Label = $ScoreLabel
onready var high_score_label: RichTextLabel = $HighScoreLabel
onready var message_timer: Timer = $MessageTimer
onready var play_button: Button = $MainMenu/VBoxContainer/PlayButton
onready var credits_button: Button = $MainMenu/VBoxContainer/CreditsButton
onready var quit_to_desktop_button: Button = $MainMenu/VBoxContainer/QuitToDesktopButton


################################# RUN THE CODE #################################


func _ready() -> void:
	self._initialize_signals()
	self._initialize()
	return


############################### DECLARE FUNCTIONS ##############################


func _initialize_signals() -> void:
	Events.connect("main_menu_requested", self, "on_main_menu_requested")
	return


func _initialize() -> void:
	$GameOverMenu.hide()
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


func show_game_over() -> void:
	$GameOverMenu.show()
	
	show_message("Game Over!")
#	yield(message_timer, "timeout")
#	message_label.text = "Dodge the Creeps"
#	message_label.show()
#	yield(get_tree().create_timer(1.0), "timeout")
	
	message_panel.show()
#	play_button.show()
#	credits_button.show()
#	quit_to_desktop_button.show()
	return


func _on_PlayButton_pressed() -> void:
	$MainMenu.hide()
#	play_button.hide()
#	credits_button.hide()
#	quit_to_desktop_button.hide()
	Events.emit_signal("game_started")
	return


func _on_MessageTimer_timeout() -> void:
	message_panel.hide()
	return
