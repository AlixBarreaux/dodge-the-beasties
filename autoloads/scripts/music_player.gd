extends AudioStreamPlayer
# class_name MusicPlayer


# ----------------------------- DECLARE VARIABLES -----------------------------


const MAIN_MENU_TRACK: String = "res://assets/sound/music/heatleybros_level_up_theme_song_8_bit_summer.ogg"
const IN_GAME_TRACK: String = "res://assets/sound/music/heatleybros_-_8_bit_win_happy_victorious_chiptune_game_music.ogg"


# ---------------------------------- RUN CODE ---------------------------------


func _ready() -> void:
	self._initialize_signals()
	self.play_track(MAIN_MENU_TRACK)
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
