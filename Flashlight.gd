extends Light2D

func _process(_delta):
	var fl_to_mouse = global_position.angle_to_point(get_global_mouse_position())
	var fl_tf = Transform2D().rotated(fmod(fl_to_mouse + PI, TAU)).scaled(Vector2(1, Constants.ISO_Y_SQUISH))
	set_transform(fl_tf)
