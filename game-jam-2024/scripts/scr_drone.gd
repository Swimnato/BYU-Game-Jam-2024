extends Node2D

enum states { ORBIT_UPPER, ORBIT_LOWER, ATTACK, COLLECT, SENTRY }
var current_state = states.ORBIT_LOWER

@onready var controller = $".."
@onready var lower_orbit_radius = controller.lower_orbit_radius
@onready var upper_orbit_radius = controller.upper_orbit_radius

@export var orbit_speed = 1
@export var attack_speed = 5

var orbit_angle = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.1
func _process(delta: float) -> void:
	match current_state:
		states.ORBIT_LOWER:
			move_orbit(lower_orbit_radius, delta)
		states.ORBIT_UPPER:
			move_orbit(upper_orbit_radius, delta)

func move_orbit(orbit_ring: float, delta) -> void:
	orbit_angle += orbit_speed * delta * 60
	position = orbit_position(orbit_angle, orbit_ring)
	
func orbit_position(theta: float, radius: float) -> Vector2:
	var x =  sin(deg_to_rad(theta)) * radius
	var y = -cos(deg_to_rad(theta)) * radius
	return Vector2(x, y)
