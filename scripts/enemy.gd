extends KinematicBody2D
class_name Enemy


############################### DECLARE VARIABLES ##############################


export var min_speed: float = 150.0
export var max_speed: float = 250.0


var direction: Vector2 = Vector2(0.0, 0.0)
var velocity: Vector2 = Vector2(0.0, 0.0)

# Node References
onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


################################# RUN THE CODE #################################


func _ready() -> void:
	$AnimatedSprite.play()
#	var enemy_types: PoolStringArray = $AnimatedSprite.frames.get_animation_names()
#	$AnimatedSprite.animation = enemy_types[randi() % enemy_types.size()]
	self._initialize_signals()
	self._initialize()
	
	return


func _physics_process(_delta: float) -> void:
	self.move_and_slide(self.velocity)
	return


############################### DECLARE FUNCTIONS ##############################


func _initialize() -> void:
	randomize()
	self.disable()
	return


func _initialize_signals() -> void:
	Events.connect("game_quited", self, "queue_free")
	Events.connect("game_started", self, "queue_free")
	return


func _on_VisibilityNotifier2D_screen_exited() -> void:
	self.queue_free()


func setup() -> void:
	self.velocity = self.direction
	self.velocity *= rand_range(self.min_speed, self.max_speed)
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
