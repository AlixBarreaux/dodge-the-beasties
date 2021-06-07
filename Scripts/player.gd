extends Area2D


############################### DECLARE VARIABLES ##############################

export var current_speed: int = 400

var direction: Vector2 = Vector2(0.0, 0.0)
var screen_size = Vector2(0.0, 0.0)

signal hit

################################# RUN THE CODE #################################


func _ready() -> void:
	self.screen_size = get_viewport_rect().size
	self.hide()


# REFACTOR INPUTS
func _physics_process(delta: float) -> void:
	self.direction = Vector2(0.0, 0.0)
	
	if Input.get_action_strength("move_left"):
		self.direction.x -= 1
	
	if Input.get_action_strength("move_right"):
		self.direction.x += 1

	if Input.get_action_strength("move_up"):
		self.direction.y -= 1
	
	if Input.get_action_strength("move_down"):
		self.direction.y += 1

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
	self.show()
	$CollisionShape2D.disabled = false


func _on_Player_body_entered(_body: PhysicsBody2D) -> void:
	self.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	self.emit_signal("hit")
