extends Node

var current_scene = null
var length = 4
var width = 4
var location_x = 0
var location_y = 0
var room_matrix = []

var rng = RandomNumberGenerator.new()


var room_resources =  [ResourceLoader.load("res://Scenes/Rooms/EmptyRoom.tscn")]

# [dx, dy] : int tuple
func travel(dist):
	# if at edge just return
	var scene_instance = room_matrix[location_x + dist[0]][location_y + dist[1]]
	call_deferred("_deferred_goto_scene", scene_instance)


func _deferred_goto_scene(scene_instance):
	get_tree().get_root().add_child(scene_instance)
	get_tree().set_current_scene(scene_instance)


func randomize_matrix(x, y):
	if (x < 0 || x > len(room_matrix) - 1 
		|| y < 0 || y > len(room_matrix[0]) - 1 
		|| room_matrix[x][y] != null):
		return;
	
	if (rng.randi_range(0, 1)):
		room_matrix[x][y] = 'null_space'
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
