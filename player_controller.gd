extends Node
class_name PlayerController


# ----------------------------- DECLARE VARIABLES -----------------------------

# ---------------------------------- RUN CODE ---------------------------------


func _unhandled_key_input(event: InputEventKey) -> void:	
	if Input.get_axis("move_left", "move_right"):
		pass
		
	if Input.get_axis("move_up", "move_down"):
		pass
	
	
	return


func _unhandled_input(event: InputEvent) -> void:
#	if event is InputEventScreenTouch:
#		print("Screen touch at: ", event.position)
#		return
	
	if event is InputEventMouseButton:
		if Input.is_action_just_released("left_mouse_button") or Input.is_action_just_released("right_mouse_button"):
			print("Mouse button pressed at: ", event.global_position)
	return


# ----------------------------- DECLARE FUNCTIONS -----------------------------
