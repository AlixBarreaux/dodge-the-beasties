extends Control
class_name PauseMenu


# ----------------- DECLARE VARIABLES -----------------


# Node References
onready var panel: Panel = $Panel


# ---------------------- RUN CODE ---------------------


func _ready() -> void:
	self._initialize()
	return


func _unhandled_key_input(event: InputEventKey) -> void:
	if not Global.can_pause_menu_show:
		return
	
	if Input.is_action_just_pressed("ui_cancel"):
		if panel.visible:
			get_tree().paused = false
			self.hide_menu()
			return
		
		get_tree().paused = true
		self.show_menu()
		return


# ----------------- DECLARE FUNCTIONS -----------------


func _initialize() -> void:
	self.hide_menu()
	return

var is_menu_shown: bool = false

func _on_IconButton_pressed() -> void:
	if not Global.can_pause_menu_show:
		return
	
	if is_menu_shown:
		get_tree().paused = false
		self.hide_menu()
		return
	
	get_tree().paused = true
	self.show_menu()
	return


func _on_ResumeButton_pressed() -> void:
	self.hide_menu()
	get_tree().paused = false
	return


func _on_QuitToMainMenuButton_pressed() -> void:
	self.hide_menu()
	Events.emit_signal("game_quited")
	Events.emit_signal("main_menu_requested")
	
	Global.can_pause_menu_show = false
	get_tree().paused = false
	return


func show_menu() -> void:
	panel.show()
	self.set_mouse_filter(MOUSE_FILTER_STOP)
	is_menu_shown = true
	return


func hide_menu() -> void:
	panel.hide()
	set_mouse_filter(MOUSE_FILTER_IGNORE)
	is_menu_shown = false
	return
