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

func travel(dx: int, dy: int, player: Object):
	if !player.has_moved:
		return
		
	print('Travel Event: [%d, %d]' % [location_x + dx, location_y + dy])
	# if at edge just return
	var next_scene = room_matrix[location_x + dx][location_y + dy]
	
	if !next_scene:
		return
	call_deferred("_deferred_goto_scene", next_scene, player)


func _deferred_goto_scene(scene_instance, player):
	# TODO Player retains location and inf loops enters a new room, 
	# set player moved state 
	# TODO have player enter next room at corresponding portal
	get_tree().get_root().get_node('Dungeon/Walls').remove_child(player)
	get_tree().get_root().remove_child(current_scene)
	get_tree().get_root().add_child(scene_instance)
	get_tree().set_current_scene(scene_instance)
	get_tree().get_root().get_node('Dungeon/Walls').add_child(player)

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
	
	travel(location_x, location_y, player)
