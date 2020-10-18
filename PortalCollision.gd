extends Sprite

export var x = 0
export var y = 0

# This function will be called by the `body_enter` signal.
# The body parameter is the node that touched the area.
func on_body_entered(body):
	if body.get_name().begins_with("Player"):
		SceneSwitcher.travel(x, y, body)

