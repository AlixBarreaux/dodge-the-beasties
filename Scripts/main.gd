extends Node


############################### DECLARE VARIABLES ##############################

export var mob_scene: PackedScene = null

var score = 0

################################# RUN THE CODE #################################

func _ready() -> void:
	randomize()

############################### DECLARE FUNCTIONS ##############################

func new_game() -> void:
	self.score = 0
	$HUD.update_score(self.score)
	
	get_tree().call_group("mobs", "queue_free")
	$Player.set_physics_process(false)
	$Player.start($StartPosition.position)
	
	$StartTimer.start()
	$Music.play()
	
	$HUD.show_message("GET_READY_MESSAGE")
	
	yield($StartTimer, "timeout")
	$Player.set_physics_process(true)
	$ScoreTimer.start()
	$MobTimer.start()


func game_over() -> void:
	$ScoreTimer.stop()
	$Music.stop()
	$DeathSound.play()


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
	$HUD.update_score(score)


func _on_Player_hit() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	
