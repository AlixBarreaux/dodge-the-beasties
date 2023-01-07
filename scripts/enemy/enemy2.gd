extends Enemy
class_name Enemy2


# ----------------------------- DECLARE VARIABLES -----------------------------

# ---------------------------------- RUN CODE ---------------------------------

# ----------------------------- DECLARE FUNCTIONS -----------------------------


func _enable_collision_polyshapes() -> void:
	$CollisionShape2D.disabled = false
	return


func _disable_collision_polyshapes() -> void:
	$CollisionShape2D.disabled = true
	return
