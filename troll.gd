extends KinematicBody2D

export var MOTION_SPEED = 160 # Pixels/second.
onready var player = $Sprite
const ISO_Y_SQUISH = tan(PI/6)

func _physics_process(_delta):
	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	motion.y *= ISO_Y_SQUISH
	motion = motion.normalized() * MOTION_SPEED
	#warning-ignore:return_value_discarded
	move_and_slide(motion)
