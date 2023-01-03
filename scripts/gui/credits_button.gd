extends Button


############################### DECLARE VARIABLES ##############################


################################# RUN THE CODE #################################

############################### DECLARE FUNCTIONS ##############################


func _on_CreditsButton_pressed() -> void:
	# warning-ignore: return_value_discarded
	OS.shell_open("https://www.youtube.com/watch?v=WEt2JHEe-do")
