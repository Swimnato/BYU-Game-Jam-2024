extends Sprite2D

var theta = 0.0;
var lastUpdate = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x = 0
	position.y = -300

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var timeSinceLastUpdate = Time.get_ticks_msec() - lastUpdate
	if timeSinceLastUpdate > 5:
		theta += .1 * (timeSinceLastUpdate / 5) # consistancy for all frameRates
		position.x = sin(theta/180.0 * PI) * 300
		position.y = -cos(theta/180.0 * PI) * 300
		rotation_degrees = theta
		lastUpdate = Time.get_ticks_msec()
