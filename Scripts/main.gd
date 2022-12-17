extends Node


############################### DECLARE VARIABLES ##############################


export var mob_scene: PackedScene = null
export var default_high_score_value: int = 3

var score: int = 0
onready var high_score: int = load_high_score()


# Node References:
onready var hud: CanvasLayer = $HUD


################################# RUN THE CODE #################################


func _ready() -> void:
	randomize()
	self._initialize_signals()
	self._initialize()


############################### DECLARE FUNCTIONS ##############################


func _initialize_signals() -> void:
	Events.connect("game_started", self, "new_game")
	return


func _initialize() -> void:
	hud.update_score(self.score)
	hud.update_high_score(self.high_score)
	return


func new_game() -> void:
	self.score = 0
	is_high_score_beat = false
	hud.update_score(self.score)
	
	get_tree().call_group("mobs", "queue_free")
	$Player.set_physics_process(false)
	$Player.start($StartPosition.position)
	
	$StartTimer.start()
	$Music.play()
	
	hud.show_message_with_timer("Ready Yourself!")
	
	yield($StartTimer, "timeout")
	$Player.set_physics_process(true)
	$ScoreTimer.start()
	$MobTimer.start()


func game_over() -> void:
	$ScoreTimer.stop()
	$Music.stop()
	$DeathSound.play()
	
	if is_high_score_beat:
		save_high_score(high_score)


const SAVE_FILE_DIRECTORY: String = "user://"
const SAVE_FILE_PATH: String = SAVE_FILE_DIRECTORY + "save.bin"

func save_high_score(value: int) -> void:
	print("Saving high score!")
	
	var _save_file: File = File.new()
	_save_file.open(SAVE_FILE_PATH, File.WRITE)
	_save_file.store_32(value)
	_save_file.close()

	return


func load_high_score() -> int:
	var _save_file: File = File.new()
	
	if not _save_file.file_exists(SAVE_FILE_PATH):
		print("The save file doesn't exist! Creating it.")
		save_high_score(default_high_score_value)
	
	var _error = _save_file.open(SAVE_FILE_PATH, File.READ)
	
	
	if _error != OK:
		printerr("(!) ERROR: Couldn't open the save file at path: ", SAVE_FILE_PATH)
		return default_high_score_value
	
	
	var saved_high_score = _save_file.get_32()
	_save_file.close()

	return saved_high_score


func _on_MobTimer_timeout() -> void:
	var mob_spawn_location: PathFollow2D = $Path2D/MobSpawnLocation
	mob_spawn_location.unit_offset = randf()
	
	var mob = mob_scene.instance()
	self.add_child(mob)
	
	mob.position = mob_spawn_location.position
	
	# PI/ 2 -> 90 degrees
	# PI / 4 -> 45
	var direction = mob_spawn_location.rotation + PI / 2
	direction += rand_range(- PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = velocity.rotated(direction)


func _on_ScoreTimer_timeout() -> void:
	score += 1
	hud.update_score(score)
	
	compare_score_with_high_score()
	
	if is_high_score_beat:
		high_score += 1
		hud.update_high_score(high_score)
	
	return


var is_high_score_beat: bool = false

func compare_score_with_high_score() -> void:
	if score > high_score:
		is_high_score_beat = true
	return


func _on_Player_hit() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	hud.show_game_over()
	
