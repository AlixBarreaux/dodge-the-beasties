extends Area2D
class_name Player


############################### DECLARE VARIABLES ##############################


export var current_speed: int = 400
var eye_rotation_speed: float = 0.08

var direction: Vector2 = Vector2(0.0, 0.0)
var screen_size = Vector2(0.0, 0.0)

var eye_target: PhysicsBody2D = null

signal hit

# Node References:
onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
onready var eye_sprite: Sprite = $EyeSprite

onready var animation_tree: AnimationTree = $AnimationTree
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var animation_node_sm_playback: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")

onready var eye_animation_tree: AnimationTree = $EyeSprite/AnimationTree
onready var eye_animation_player: AnimationPlayer = $EyeSprite/AnimationPlayer
onready var eye_animation_node_sm_playback: AnimationNodeStateMachinePlayback = $EyeSprite/AnimationTree.get("parameters/playback")


################################# RUN THE CODE #################################


func _ready() -> void:
	self._initialize_signals()
	self._initialize()
	return


func _initialize_signals() -> void:
	Events.connect("game_quited", self, "disable")
	
	# PLAY BOTH ANIMATION PLAYERS!
	Events.connect("start_timer_timeout", self, "on_start_timer_timeout")
	return


func _initialize() -> void:
	self.screen_size = get_viewport_rect().size
	self.hide()
	
	animation_tree.active = true
	eye_animation_tree.active = true
	
	eye_animation_node_sm_playback.travel("Prepare")
	animation_node_sm_playback.travel("Idle")
	
	return


func on_start_timer_timeout() -> void:
	animation_node_sm_playback.travel("Idle")
	eye_animation_node_sm_playback.travel("Idle")
	return


# REFACTOR INPUTS
func _physics_process(delta: float) -> void:
	self.direction = Vector2(0.0, 0.0)
	
	self.direction.x = Input.get_axis("move_left", "move_right")
	self.direction.y = Input.get_axis("move_up", "move_down")

	# Player is pressing at least one key
#	if self.direction.length() > 0:
	self.direction = self.direction.normalized()
	


	self.position += self.direction * self.current_speed * delta
	self.position.x = clamp(self.position.x, 0, screen_size.x)
	self.position.y = clamp(self.position.y, 0, screen_size.y)


	if self.direction != Vector2(0.0, 0.0):
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	if self.direction.x != 0:
		$AnimatedSprite.animation = "Move Right"
		$AnimatedSprite.flip_v = false
		
		if self.direction.x < 0:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
	
	
	elif self.direction.y != 0:
		$AnimatedSprite.animation = "Move Up"
		
		if self.direction.y < 0:
			$AnimatedSprite.flip_v = false
		else:
			$AnimatedSprite.flip_v = true
	
	
	if self.eye_target != null:
		if is_instance_valid(self.eye_target):
			eye_sprite.rotation = lerp_angle(eye_sprite.rotation,
			(
				self.eye_target.global_position - eye_sprite.global_position).normalized().angle(),
				eye_rotation_speed
			)
		else:
			eye_sprite.rotation = lerp_angle(eye_sprite.rotation, 0.0, eye_rotation_speed)


############################### DECLARE FUNCTIONS ##############################


# Initialize the player
func start(new_position: Vector2) -> void:
	self.position = new_position
	self.spawn()


func _on_Player_body_entered(_body: PhysicsBody2D) -> void:
	die()


func die() -> void:
	print(self.name, " die()")
	animation_node_sm_playback.travel("Die")
	eye_animation_node_sm_playback.travel("Die")
	Events.emit_signal("player_defeated")
#	self.disable()
	return


func spawn() -> void:
	animation_player.play("RESET")
	eye_animation_player.play("RESET")
	
	self.enable()
	
	animation_node_sm_playback.travel("Idle")
	eye_animation_node_sm_playback.travel("Prepare")
	
	return


func enable() -> void:
	print(self.name, " enable()")
	collision_shape_2d.disabled = false
	return


func disable() -> void:
	print(self.name, " disable()")
	collision_shape_2d.set_deferred("disabled", true)
	return


func _on_MobDetectZone_body_entered(body: PhysicsBody2D) -> void:
	self.eye_target = body
	return
