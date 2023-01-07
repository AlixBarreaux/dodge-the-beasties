extends RigidBody2D


############################### DECLARE VARIABLES ##############################


export var min_speed: int = 150
export var max_speed: int = 250


################################# RUN THE CODE #################################


func _ready() -> void:
	$AnimatedSprite.play()
	var mob_types: PoolStringArray = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	
	Events.connect("game_quited", self, "queue_free")
	Events.connect("game_started", self, "queue_free")


############################### DECLARE FUNCTIONS ##############################


func _on_VisibilityNotifier2D_screen_exited() -> void:
	self.queue_free()
