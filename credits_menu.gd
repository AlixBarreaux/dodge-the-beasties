extends Control
class_name CreditsMenu


# ----------------------------- DECLARE VARIABLES -----------------------------


# Node References
onready var first_element_to_focus: Button = $Panel/BackButton


# ---------------------------------- RUN CODE ---------------------------------

# ----------------------------- DECLARE FUNCTIONS -----------------------------


func _on_BackButton_pressed() -> void:
	self.hide()
	return


func _on_CreditsMenu_visibility_changed() -> void:
	if self.visible:
		self.first_element_to_focus.grab_focus()
	else:
		self.first_element_to_focus.release_focus()
	
	return
