extends Node
class_name PlayerController


# ----------------------------- DECLARE VARIABLES -----------------------------

signal input_movement_direction_sent

# ---------------------------------- RUN CODE ---------------------------------

var direction: Vector2 = Vector2(0.0, 0.0)

#func _unhandled_key_input(event: InputEventKey) -> void:
#	self.direction.x = Input.get_axis("move_left", "move_right")
#	self.direction.y = Input.get_axis("move_up", "move_down")
#
#	emit_signal("input_direction_sent")
#
#	return


func _unhandled_input(event: InputEvent) -> void:
	direction = Vector2(0.0, 0.0)
	
	#	if event is InputEventScreenTouch:
#		print("Screen touch at: ", event.position)
#		return
	if direction == Vector2(0.0, 0.0):
		if event is InputEventMouseButton:
			if Input.is_action_just_released("left_mouse_button") or Input.is_action_just_released("right_mouse_button"):
				print("Mouse button pressed at: ", event.global_position)
				direction = event.global_position
	
	
	self.direction.x = Input.get_axis("move_left", "move_right")
	self.direction.y = Input.get_axis("move_up", "move_down")
	
	
	direction = direction.normalized()
	
#	if self.direction == Vector2(0.0, 0.0):
##		print(self.name, " : Direction ZERO -> ", direction)
#		return
	
	print(self.name, " : Direction -> ", direction)
	emit_signal("input_movement_direction_sent", self.direction)
	
	return


# ----------------------------- DECLARE FUNCTIONS -----------------------------
