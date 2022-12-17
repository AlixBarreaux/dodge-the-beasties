extends Control
class_name MainMenu


# ----------------- DECLARE VARIABLES -----------------

# ---------------------- RUN CODE ---------------------


func _ready() -> void:
	self._initialize_signals()
	return


# ----------------- DECLARE FUNCTIONS -----------------


func _initialize_signals() -> void:
	Events.connect("main_menu_requested", self, "show")
	return
