extends Node

var length = 4
var width = 4
var location_x = 0
var location_y = 0
var room_matrix = []

var current_scene = null

var null_room = false

var rng = RandomNumberGenerator.new()


var room_resources =  [ResourceLoader.load("res://Scenes/Rooms/EmptyRoom.tscn")]

func entering_door_name(dx, dy):
	if dx == 0 && dy == 1:
		return 'SouthWest'
	if dx == 1 && dy == 0:
		return 'NorthWest'
	if dx == 0 && dy == -1:
		return 'NorthEast'
	if dx == -1 && dy == 0:
		return 'SouthEast'
		
func travel(dx: int, dy: int, player: Object):
	# if at edge just return
	
	var new_x = location_x + dx
	var new_y = location_y + dy
	if new_x < 0 || new_y < 0 || new_x >= len(room_matrix) || new_y >= len(room_matrix[0]):
		return
	
	print('Travel Event [%d, %d]' % [dx, dy])
	var next_scene = room_matrix[location_x + dx][location_y + dy]
	
	if !next_scene:
		return
		
	location_x += dx
	location_y += dy
	# no more collision events for this person
	print('Disabling Collision')
	player.get_node('CollisionShape2D').disabled = true
	call_deferred("_deferred_goto_scene", next_scene, player, dx, dy)


func _deferred_goto_scene(scene_instance, player, dx, dy):	
	
	# TODO Player retains location and inf loops enters a new room, 
	# set player moved state 
	# TODO have player enter next room at corresponding portal
	get_tree().get_root().get_node('Dungeon/Walls').remove_child(player)
	get_tree().get_root().remove_child(current_scene)
	get_tree().get_root().add_child(scene_instance)
	get_tree().set_current_scene(scene_instance)
	get_tree().get_root().get_node('Dungeon/Walls').add_child(player)
	
	current_scene = scene_instance

	if !(dx == 0 and dy == 0):
		print('Floor/' + entering_door_name(dx, dy))
		var door = scene_instance.get_node('Floor/' + entering_door_name(dx, dy))
		player.position = door.position
	else:
		print('Starting')
	
	# re-enable collision
	print('Enabling Collision')
	player.get_node('CollisionShape2D').disabled = false
	print('Current Room: [%d, %d]' % [location_x, location_y])

func randomize_matrix(x, y):
	if (x < 0 || x > len(room_matrix) - 1 
		|| y < 0 || y > len(room_matrix[0]) - 1 
		|| room_matrix[x][y] != null):
		return;
	
	if (rng.randi_range(0, 1)):
		room_matrix[x][y] = null_room
		return
	var room = room_resources[rng.randi_range(0, len(room_resources) - 1)]
	print('Putting [' + str(x) + ', ' + str(y) + '] as' + room.resource_path)
	# assign random room to self
	room_matrix[x][y] = room.instance()
	randomize_matrix(x + 1, y)
	randomize_matrix(x - 1, y)
	randomize_matrix(x, y + 1)
	randomize_matrix(x , y - 1)

func _ready():
	rng.randomize()
	
	# initialize matrix
	for i in range(length):
		room_matrix.append([])
		for _j in range(width):
			room_matrix[i].append(null)
	room_matrix[0][0] = room_resources[rng.randi_range(0, len(room_resources) - 1)].instance()
	randomize_matrix(1, 0)
	randomize_matrix(0, 1)
	
	var player = ResourceLoader.load("res://troll.tscn").instance()
	# TODO: move player creation logic
	get_tree().get_root().get_node('Dungeon/Walls').add_child(player)
	
	travel(0, 0, player)
