extends Node
class_name Main


# ----------------------------- DECLARE VARIABLES -----------------------------


export var enemy_scene: PackedScene = null
# If the game is opened for the first time and no save file is present,
# the high score is set to this value
export var default_high_score_value: int = 90

var score: int = 0
onready var high_score: int = load_high_score()
var is_high_score_beat: bool = false


# Node References:
onready var hud: CanvasLayer = $HUD
onready var player: KinematicBody2D = $Player
onready var score_timer: Timer = $ScoreTimer
onready var enemy_timer: Timer = $EnemyTimer
onready var death_sound_player: AudioStreamPlayer = $DeathSoundPlayer
onready var start_timer: Timer = $StartTimer
onready var player_starting_position: Position2D = $PlayerStartingPosition


# ---------------------------------- RUN CODE ---------------------------------


func _ready() -> void:
	randomize()
	self._initialize_signals()
	self._initialize()
	return


# ----------------------------- DECLARE FUNCTIONS -----------------------------


func _initialize_signals() -> void:
	Events.connect("game_started", self, "on_game_started")
	Events.connect("game_quited", self, "on_game_quited")
	Events.connect("player_defeated", self, "on_player_defeated")
	return


func on_game_quited() -> void:
	self.stop_game()
	return


func stop_game() -> void:
#	self.score = 0
	is_high_score_beat = false
	hud.update_score(self.score)
	score_timer.stop()
	enemy_timer.stop()
	score_timer.stop()
	
	if is_high_score_beat:
		save_high_score(high_score)
	
	return


func _initialize() -> void:
	hud.update_score(self.score)
	hud.update_high_score(self.high_score)
	return


func on_game_started() -> void:
	Global.can_pause_menu_show = true
	self.score = 0
	is_high_score_beat = false
	hud.update_score(self.score)
	player.spawn(player_starting_position.position)
	
	start_timer.start()
	
	hud.show_message_with_timer("Ready Yourself!")
	
	yield(start_timer, "timeout")
	player.set_physics_process(true)
	score_timer.start()
	enemy_timer.start()
	
	return


func on_player_defeated() -> void:
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


func _on_EnemyTimer_timeout() -> void:
	var _enemy_spawn_location: PathFollow2D = $Path2D/EnemySpawnLocation
	_enemy_spawn_location.unit_offset = randf()
	
	var _enemy: Object = enemy_scene.instance()
	self.add_child(_enemy)
	
	
	# Set enemy values
	_enemy.position = _enemy_spawn_location.position
	
	# PI / 2 -> 90 degrees
	# PI / 4 -> 45
	var _direction_angle: float = _enemy_spawn_location.rotation + PI / 2
	_direction_angle += rand_range(- PI / 4, PI / 4)


	_enemy.rotate(_direction_angle)
	_enemy.direction = Vector2(cos(_direction_angle), sin(_direction_angle))
	
	_enemy.setup()
	_enemy.enable()
	
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
