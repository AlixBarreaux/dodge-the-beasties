extends Area2D
class_name Player


############################### DECLARE VARIABLES ##############################


export var current_speed: int = 400

var direction: Vector2 = Vector2(0.0, 0.0)
var screen_size = Vector2(0.0, 0.0)

signal hit

# Node References:
onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


################################# RUN THE CODE #################################


func _ready() -> void:
	self._initialize_signals()
	self.screen_size = get_viewport_rect().size
	self.hide()
	return


func _initialize_signals() -> void:
	Events.connect("game_quited", self, "disable")
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


############################### DECLARE FUNCTIONS ##############################


# Initialize the player
func start(new_position: Vector2) -> void:
	self.position = new_position
	enable()


func _on_Player_body_entered(_body: PhysicsBody2D) -> void:
	disable()
	Events.emit_signal("player_defeated")


func enable() -> void:
	self.show()
	collision_shape_2d.disabled = false
	return


func disable() -> void:
	self.hide()
	collision_shape_2d.set_deferred("disabled", true)
	return
