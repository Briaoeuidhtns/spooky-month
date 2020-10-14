extends Light2D

const ISO_Y_SQUISH = tan(PI/6)

func _process(_delta):
	var fl_to_mouse = global_position.angle_to_point(get_global_mouse_position())
	var fl_tf = Transform2D().rotated(fmod(fl_to_mouse + PI, TAU)).scaled(Vector2(1, ISO_Y_SQUISH))
	set_transform(fl_tf)
