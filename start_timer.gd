extends Timer
class_name StartTimer


# ----------------------------- DECLARE VARIABLES -----------------------------

# ---------------------------------- RUN CODE ---------------------------------

# ----------------------------- DECLARE FUNCTIONS -----------------------------


func _on_StartTimer_timeout() -> void:
	Events.emit_signal("start_timer_timeout")
	return
