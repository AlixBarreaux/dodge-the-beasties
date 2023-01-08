extends LinkButton
class_name BrowserLinkButton


# ----------------- DECLARE VARIABLES -----------------


export var url: String = ""


# ----------------- RUN CODE -----------------


func _ready() -> void:
	self.initialize_asserts()
	return


# ----------------- DECLARE FUNCTIONS -----------------


func initialize_asserts() -> void:
	if self.url == "":
		printerr("(!) Error: In" + self.name + ": The URL must be set!")
	return


func _on_pressed() -> void:
	OS.shell_open(url)
	return
