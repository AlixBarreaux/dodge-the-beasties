extends RichTextLabel
class_name RichTextLabelGameName


# ----------------------------- DECLARE VARIABLES -----------------------------

# ---------------------------------- RUN CODE ---------------------------------


func _ready() -> void:
	self.bbcode_text = "[center]" + ProjectSettings.get("application/config/name") + "[/center]"
	return


# ----------------------------- DECLARE FUNCTIONS -----------------------------
