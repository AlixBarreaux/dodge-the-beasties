extends Node
class_name Main


############################### DECLARE VARIABLES ##############################


export var mob_scene: PackedScene = null
# If the game is opened for the first time and no save file is present,
# the high score is set to this value
export var default_high_score_value: int = 90

var score: int = 0
onready var high_score: int = load_high_score()
var is_high_score_beat: bool = false


# Node References:
onready var hud: CanvasLayer = $HUD
onready var player: Area2D = $Player
onready var score_timer: Timer = $ScoreTimer
onready var mob_timer: Timer = $MobTimer
onready var music_player: AudioStreamPlayer = $MusicPlayer
onready var death_sound_player: AudioStreamPlayer = $DeathSoundPlayer
onready var start_timer: Timer = $StartTimer
onready var player_starting_position: Position2D = $PlayerStartingPosition


################################# RUN THE CODE #################################


func _ready() -> void:
	randomize()
	self._initialize_signals()
	self._initialize()
	return


############################### DECLARE FUNCTIONS ##############################


func _initialize_signals() -> void:
	Events.connect("game_started", self, "on_game_started")
	Events.connect("game_quited", self, "on_game_quited")
	Events.connect("player_defeated", self, "on_player_defeated")
	return


func on_game_quited() -> void:
	stop_game()
	return


func stop_game() -> void:
	print("stop game")
#	self.score = 0
	is_high_score_beat = false
	hud.update_score(self.score)
	get_tree().call_group("mobs", "queue_free")
	player.set_physics_process(false)
	score_timer.stop()
	mob_timer.stop()
	score_timer.stop()
	music_player.stop()
	
	if is_high_score_beat:
		save_high_score(high_score)
	
	return


func _initialize() -> void:
	hud.update_score(self.score)
	hud.update_high_score(self.high_score)
	return


func on_game_started() -> void:
	self.score = 0
	is_high_score_beat = false
	hud.update_score(self.score)
	
	get_tree().call_group("mobs", "queue_free")
	player.set_physics_process(false)
	player.start(player_starting_position.position)
	
	start_timer.start()
	music_player.play()
	
	hud.show_message_with_timer("Ready Yourself!")
	
	yield(start_timer, "timeout")
	player.set_physics_process(true)
	score_timer.start()
	mob_timer.start()
	
	return


func on_player_defeated() -> void:
	print("game over")
	stop_game()
	death_sound_player.play()
	return


# Save / Load save file

const SAVE_FILE_DIRECTORY: String = "user://"
const SAVE_FILE_PATH: String = SAVE_FILE_DIRECTORY + "save.bin"

func save_high_score(value: int) -> void:
	var _save_file: File = File.new()
	var _error: int = _save_file.open(SAVE_FILE_PATH, File.WRITE)
	
	if _error != OK:
		printerr("(!) ERROR: Couldn't open the save file at path: ", SAVE_FILE_PATH)
		return
	
	_save_file.store_32(value)
	_save_file.close()

	return


func load_high_score() -> int:
	var _save_file: File = File.new()
	
	if not _save_file.file_exists(SAVE_FILE_PATH):
		save_high_score(default_high_score_value)
	
	var _error: int = _save_file.open(SAVE_FILE_PATH, File.READ)
	
	
	if _error != OK:
		printerr("(!) ERROR: Couldn't open the save file at path: ", SAVE_FILE_PATH)
		return default_high_score_value
	
	
	var _saved_high_score: int = _save_file.get_32()
	_save_file.close()

	return _saved_high_score


func _on_MobTimer_timeout() -> void:
	var _mob_spawn_location: PathFollow2D = $Path2D/MobSpawnLocation
	_mob_spawn_location.unit_offset = randf()
	
	var _mob: Object = mob_scene.instance()
	self.add_child(_mob)
	
	_mob.position = _mob_spawn_location.position
	
	# PI/ 2 -> 90 degrees
	# PI / 4 -> 45
	var _direction: float = _mob_spawn_location.rotation + PI / 2
	_direction += rand_range(- PI / 4, PI / 4)
	_mob.rotation = _direction
	
	var _velocity: Vector2 = Vector2(rand_range(_mob.min_speed, _mob.max_speed), 0)
	_mob.linear_velocity = _velocity.rotated(_direction)
	
	return


func _on_ScoreTimer_timeout() -> void:
	score += 1
	hud.update_score(score)
	
	compare_score_with_high_score()
	
	if is_high_score_beat:
		high_score += 1
		hud.update_high_score(high_score)
	
	return


func compare_score_with_high_score() -> void:
	if score > high_score:
		is_high_score_beat = true
	return
