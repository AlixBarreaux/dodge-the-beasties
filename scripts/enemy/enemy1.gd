extends Enemy
class_name Enemy1


# ----------------------------- DECLARE VARIABLES -----------------------------

# ---------------------------------- RUN CODE ---------------------------------

# ----------------------------- DECLARE FUNCTIONS -----------------------------


func _enable_collision_polyshapes() -> void:
	$CollisionPolygon2D.disabled = false
	return


func _disable_collision_polyshapes() -> void:
	$CollisionPolygon2D.disabled = true
	return
