extends AudioStreamPlayer
# class_name MusicPlayer


# ----------------------------- DECLARE VARIABLES -----------------------------

const MAIN_MENU_TRACK: String = "res://assets/sound/music/mokkamusic_-_funk_guitar_groove.ogg"
const IN_GAME_TRACK: String = "res://assets/sound/music/funkytown_-_upbeat_funk_tv_show_by_infraction.ogg"

# ---------------------------------- RUN CODE ---------------------------------


func _ready() -> void:
	self._initialize_signals()
	return


# ----------------------------- DECLARE FUNCTIONS -----------------------------


func _initialize_signals() -> void:
	Events.connect("game_started", self, "play_track", [self.IN_GAME_TRACK])
	Events.connect("game_quited", self, "play_track", [self.MAIN_MENU_TRACK])
	Events.connect("player_defeated", self, "stop")
	Events.connect("main_menu_requested", self, "play_track", [self.MAIN_MENU_TRACK])
	return


func play_track(track: String) -> void:
	self.stream = load(track)
	self.play()
	return
