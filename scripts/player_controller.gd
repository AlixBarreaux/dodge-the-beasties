extends Node
class_name PlayerController


# ----------------------------- DECLARE VARIABLES -----------------------------


var direction: Vector2 = Vector2(0.0, 0.0)

signal input_movement_direction_sent
signal input_movement_mouse_sent


# ---------------------------------- RUN CODE ---------------------------------


func _unhandled_input(event: InputEvent) -> void:
	direction = Vector2(0.0, 0.0)
	
	#	if event is InputEventScreenTouch:
#		print("Screen touch at: ", event.position)
#		return
#	if direction == Vector2(0.0, 0.0):

	if event is InputEventMouseButton or event is InputEventMouseMotion:
		if Input.is_action_pressed("left_mouse_button") or Input.is_action_pressed("right_mouse_button"):
			if event.global_position != Vector2(0.0, 0.0):
				emit_signal("input_movement_mouse_sent", event.global_position)
			
		elif Input.is_action_just_released("left_mouse_button") or Input.is_action_just_released("right_mouse_button"):
			emit_signal("input_movement_mouse_sent", Vector2(0.0, 0.0))
		return
	
	
	self.direction.x = Input.get_axis("move_left", "move_right")
	self.direction.y = Input.get_axis("move_up", "move_down")
	
	direction = direction.normalized()
	
	print(self.name, " : Direction -> ", direction)
	emit_signal("input_movement_direction_sent", self.direction)
	
	return


# ----------------------------- DECLARE FUNCTIONS -----------------------------
