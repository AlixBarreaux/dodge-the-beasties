extends Label


# ----------------------------- DECLARE VARIABLES -----------------------------

# ---------------------------------- RUN CODE ---------------------------------


func _ready() -> void:
	self.text = TranslationServer.tr("Version") + ": " + ProjectSettings.get("application/config/version")
	return


# ----------------------------- DECLARE FUNCTIONS -----------------------------
