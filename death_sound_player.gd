extends AudioStreamPlayer
class_name DeathSoundPlayer


# ----------------- DECLARE VARIABLES -----------------

# ---------------------- RUN CODE ---------------------


func _ready() -> void:
	self._initialize_signals()
	return


# ----------------- DECLARE FUNCTIONS -----------------


func _initialize_signals() -> void:
	Events.connect("main_menu_requested", self, "stop")
	Events.connect("game_started", self, "stop")
	return
