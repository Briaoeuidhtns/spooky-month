extends AnimatedSprite

# this will have to be updated when the monster 
# changes rooms
onready var nav_2d : Navigation2D = null

export var monster_name = "Rawr"
var speed = 70
var velocity = Vector2.ZERO
var player = null
var path = PoolVector2Array() setget set_path

enum  {
	IDLE = 0,
	PATROLLING = 1,
	CHASING = 2,
}

var state = IDLE

func _ready() -> void:
	nav_2d = get_tree().get_root().get_node('Dungeon')
	set_process(false)

func on_body_entered(body):
	if body.get_name().begins_with("Player"):
		player = body
		set_process(true)
		state = CHASING
		print('chasing')

func on_body_exited(body):
	if body.get_name().begins_with("Player"):
		player = null
		set_process(false)
		state = IDLE
		print('idle')

func _process(delta: float) -> void:
	var move_distance = speed * delta
	if player:
		path = nav_2d.get_simple_path(global_position, player.global_position)
		move_along_path(move_distance)

func move_along_path(distance : float) -> void:
	print('moving')
	print(path)
	var start_point = position
	for i in range(path.size()):
		var distance_to_next = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			position = start_point.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif distance < 0.0:
			position = path[0]
			set_process(false)
			break
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)

func set_path(value : PoolVector2Array) -> void:
	path = value
	if value.size() == 0:
		return
	set_process(true)
