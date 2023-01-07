extends KinematicBody2D
class_name Mob


############################### DECLARE VARIABLES ##############################


export var min_speed: int = 150
export var max_speed: int = 250


################################# RUN THE CODE #################################


func _ready() -> void:
	$AnimatedSprite.play()
#	var mob_types: PoolStringArray = $AnimatedSprite.frames.get_animation_names()
#	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

	randomize()
	self.disable()
	
	Events.connect("game_quited", self, "queue_free")
	Events.connect("game_started", self, "queue_free")


onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var direction: Vector2 = Vector2(0.0, 0.0)
var velocity: Vector2 = Vector2(0.0, 0.0)

func setup() -> void:
	self.velocity = self.direction
	self.velocity *= Vector2(rand_range(self.min_speed, self.max_speed), 0.0)
	return

func enable() -> void:
	collision_shape_2d.disabled = false
	self.set_physics_process(true)
	self.show()
	
	
	
	return

func disable() -> void:
	collision_shape_2d.disabled = true
	self.set_physics_process(false)
	self.hide()
	return

func _physics_process(_delta: float) -> void:
	self.move_and_slide(self.velocity)
	return


############################### DECLARE FUNCTIONS ##############################


func _on_VisibilityNotifier2D_screen_exited() -> void:
	self.queue_free()
