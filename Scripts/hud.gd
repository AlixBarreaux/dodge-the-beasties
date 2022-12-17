extends CanvasLayer

signal game_started

############################### DECLARE VARIABLES ##############################


# Node References
onready var message_panel: Panel = $MessagePanel
onready var message_label: Label = message_panel.get_node("MessageLabel")
onready var score_label: Label = $ScoreLabel
onready var message_timer: Timer = $MessageTimer
onready var play_button: Button = $PlayButton
onready var credits_button: Button = $CreditsButton
onready var quit_to_desktop_button: Button = $QuitToDesktopButton


################################# RUN THE CODE #################################

############################### DECLARE FUNCTIONS ##############################


func update_score(score: int) -> void:
	score_label.text = str(score)


func show_message(message: String) -> void:
	message_label.text = message
	message_label.show()
	message_timer.start()


func show_game_over() -> void:
	show_message("Game Over!")
	yield(message_timer, "timeout")
	message_label.text = "Dodge the Creeps"
	message_label.show()
	yield(get_tree().create_timer(1.0), "timeout")
	
	message_panel.show()
	play_button.show()
	credits_button.show()
	quit_to_desktop_button.show()


func _on_PlayButton_pressed() -> void:
	play_button.hide()
	credits_button.hide()
	quit_to_desktop_button.hide()
	self.emit_signal("game_started")


func _on_MessageTimer_timeout() -> void:
	message_panel.hide()
	message_label.hide()
