extends KinematicBody2D

export var MOTION_SPEED = 160 # Pixels/second.
export var has_moved = true

onready var player = $Sprite

func _physics_process(_delta):
	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	motion.y *= Constants.ISO_Y_SQUISH
	motion = motion.normalized() * MOTION_SPEED
	#warning-ignore:return_value_discarded
	
	has_moved = true
	
	move_and_slide(motion)
