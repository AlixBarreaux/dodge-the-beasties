extends KinematicBody2D
class_name Player


############################### DECLARE VARIABLES ##############################


export var current_speed: int = 400
export var eye_rotation_speed: float = 0.08

var direction: Vector2 = Vector2(0.0, 0.0)
var velocity: Vector2 = Vector2(0.0, 0.0)

var screen_size = Vector2(0.0, 0.0)

var eye_target: PhysicsBody2D = null


# Node References:
onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
onready var eye_sprite: Sprite = $EyeSprite

onready var animation_tree: AnimationTree = $AnimationTree
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var animation_node_sm_playback: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")

onready var eye_animation_tree: AnimationTree = $EyeSprite/AnimationTree
onready var eye_animation_player: AnimationPlayer = $EyeSprite/AnimationPlayer
onready var eye_animation_node_sm_playback: AnimationNodeStateMachinePlayback = $EyeSprite/AnimationTree.get("parameters/playback")

onready var player_controller: Node = $PlayerController


################################# RUN THE CODE #################################


func _ready() -> void:
	self._initialize_signals()
	self._initialize()
	return


# This var is here to fine tune movements later
var distance_between_click_and_player: float = 0.0
var mouse_event_global_position: Vector2 = Vector2(0.0, 0.0)


func on_input_movement_mouse_sent(value: Vector2) -> void:
	self.mouse_event_global_position = value
	self.distance_between_click_and_player = value.distance_to(get_parent().global_position)
	return


func _physics_process(delta: float) -> void:
	if not mouse_event_global_position == Vector2(0.0, 0.0):
		direction = (mouse_event_global_position - global_position).normalized()

	velocity = self.direction * self.current_speed
	self.move_and_slide(self.velocity)


	self.position.x = clamp(self.position.x, 0, screen_size.x)
	self.position.y = clamp(self.position.y, 0, screen_size.y)

	if self.eye_target != null:
		if is_instance_valid(self.eye_target):
			eye_sprite.rotation = lerp_angle(eye_sprite.rotation,
			(
				self.eye_target.global_position - eye_sprite.global_position).normalized().angle(),
				eye_rotation_speed
			)
		else:
			eye_sprite.rotation = lerp_angle(eye_sprite.rotation, 0.0, eye_rotation_speed)

	if self.direction == Vector2(0.0, 0.0):
		animation_node_sm_playback.travel("Idle")
		return

	animation_tree.set("parameters/Move/blend_position", self.direction)
	animation_node_sm_playback.travel("Move")

	return


############################### DECLARE FUNCTIONS ##############################


func set_direction(value: Vector2) -> void:
	self.direction = value
	return


func _initialize_signals() -> void:
	Events.connect("game_quited", self, "on_game_quited")
	Events.connect("game_started", self, "on_game_started")
	Events.connect("start_timer_timeout", self, "on_start_timer_timeout")
	
	player_controller.connect("input_movement_mouse_sent", self, "on_input_movement_mouse_sent")
	player_controller.connect("input_movement_direction_sent", self, "set_direction")
	
	return


func _initialize() -> void:
	self.screen_size = get_viewport_rect().size
	
	self.disable()
	self.hide()
	
	animation_tree.active = true
	eye_animation_tree.active = true
	
	return


func on_game_started() -> void:
	eye_animation_node_sm_playback.start("Prepare")
	animation_node_sm_playback.start("Idle")
	return


func on_game_quited() -> void:
	self.disable()
	self.hide()
	return


func on_start_timer_timeout() -> void:
	eye_animation_node_sm_playback.travel("Idle")
	return


func _on_HitBox_body_entered(body: PhysicsBody2D) -> void:
	die()
	return


func die() -> void:
	animation_node_sm_playback.travel("Die")
	eye_animation_node_sm_playback.travel("Die")
	Events.emit_signal("player_defeated")
	self.disable()
	return


func spawn(new_position: Vector2) -> void:
	self.position = new_position
	animation_player.play("RESET")
	eye_animation_player.play("RESET")
	
	self.enable()
	
	animation_node_sm_playback.travel("Idle")
	eye_animation_node_sm_playback.travel("Prepare")
	
	return


func enable() -> void:
	collision_shape_2d.disabled = false
	self.set_physics_process(true)
	return


func disable() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	self.set_physics_process(false)
	return


func _on_EnemyDetectZone_body_entered(body: PhysicsBody2D) -> void:
	self.eye_target = body
	return
