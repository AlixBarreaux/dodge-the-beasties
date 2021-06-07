extends CanvasLayer

signal game_started

############################### DECLARE VARIABLES ##############################

onready var message_label: Label = $MessagePanel/MessageLabel

################################# RUN THE CODE #################################


############################### DECLARE FUNCTIONS ##############################

func update_score(score: int) -> void:
	$ScoreLabel.text = str(score)


func show_message(message: String) -> void:
	message_label.text = message
	message_label.show()
	$MessageTimer.start()


func show_game_over() -> void:
	show_message("Game Over!")
	yield($MessageTimer, "timeout")
	message_label.text = "Dodge the Creeps"
	message_label.show()
	yield(get_tree().create_timer(1.0), "timeout")
	
	$MessagePanel.show()
	$Button.show()
	$CreditsButton.show()
	$QuitToDesktopButton.show()


func _on_Button_pressed() -> void:
	$Button.hide()
	$CreditsButton.hide()
	$QuitToDesktopButton.hide()
	self.emit_signal("game_started")


func _on_MessageTimer_timeout() -> void:
	$MessagePanel.hide()
	message_label.hide()
