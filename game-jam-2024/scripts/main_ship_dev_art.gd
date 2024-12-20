extends Sprite2D

var theta = 0.0;
@export var orbitSpeed = 10;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x = 0
	position.y = -300

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	theta += (delta * orbitSpeed) # consistancy for all frameRates
	position.x = sin(theta/180.0 * PI) * 300
	position.y = -cos(theta/180.0 * PI) * 300
	rotation_degrees = theta
	if(theta >= 360):
		theta -= 360;
