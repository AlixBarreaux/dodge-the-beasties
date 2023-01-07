extends KinematicBody2D
class_name Enemy


# Base Enemy class.

# To create an enemy make sure to:
# extend this class and follow the instructions at method:
# enable / _disable_collision_polyshapes

############################### DECLARE VARIABLES ##############################


export var min_speed: float = 150.0
export var max_speed: float = 250.0


var direction: Vector2 = Vector2(0.0, 0.0)
var velocity: Vector2 = Vector2(0.0, 0.0)

# Node References
onready var animation_player: AnimationPlayer = $AnimationPlayer


################################# RUN THE CODE #################################


func _ready() -> void:
	self._initialize_signals()
	self._initialize()
	
	return


func _physics_process(_delta: float) -> void:
	self.move_and_slide(self.velocity)
	return


############################### DECLARE FUNCTIONS ##############################


func _initialize_signals() -> void:
	Events.connect("game_quited", self, "queue_free")
	Events.connect("game_started", self, "queue_free")
	return


func _initialize() -> void:
	randomize()
	self.disable()
	return


func _on_VisibilityNotifier2D_screen_exited() -> void:
	self.queue_free()


func setup() -> void:
	self.velocity = self.direction
	self.velocity *= rand_range(self.min_speed, self.max_speed)
	return


func enable() -> void:
	self._enable_collision_polyshapes()
	self.set_physics_process(true)
	self.show()
	self.animation_player.play("Move")
	return


func disable() -> void:
	self._disable_collision_polyshapes()
	self.set_physics_process(false)
	self.hide()
	self.animation_player.stop()
	return


# Override this to add custom CollisionShape/Polygon2D (s)
func _enable_collision_polyshapes() -> void:
	printerr(self.name + "_enable_collision_polyshapes() must be overriden!")
	printerr("Please add a CollisionShape/Polygon2D to the scene tree and add code into this method to enable it.")
	return


# Override this to add custom CollisionShape/Polygon2D (s)
func _disable_collision_polyshapes() -> void:
	printerr(self.name + "_disable_collision_polyshapes() must be overriden!")
	printerr("Please add a CollisionShape/Polygon2D to the scene tree and add code into this method to disable it.")
	return
