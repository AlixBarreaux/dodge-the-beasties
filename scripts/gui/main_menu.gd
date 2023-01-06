extends Control
class_name MainMenu


# ----------------- DECLARE VARIABLES -----------------


# Node References
onready var animation_player: AnimationPlayer = $AnimationPlayer


# ---------------------- RUN CODE ---------------------


func _ready() -> void:
	self._initialize_signals()
	self._initialize()
	return


# ----------------- DECLARE FUNCTIONS -----------------


func _initialize_signals() -> void:
	Events.connect("game_started", self, "on_game_started")
	Events.connect("game_quited", self, "on_game_quited")
	return


func _initialize() -> void:
	self.animation_player.play("Active")
	return


func on_game_started() -> void:
	self.animation_player.stop()
	return


func on_game_quited() -> void:
	self.show()
	self.animation_player.play("Active")
	return


func _on_PlayButton_pressed() -> void:
	self.hide()
	Events.emit_signal("game_started")
	return
