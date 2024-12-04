extends Node2D

enum states { ORBIT_UPPER, ORBIT_LOWER, ATTACK, COLLECT, SENTRY }
var current_state = states.ORBIT_LOWER

@onready var controller = $".."
@onready var lower_orbit_radius = controller.lower_orbit_radius
@onready var upper_orbit_radius = controller.upper_orbit_radius

@export var orbit_speed = 1
@export var attack_speed = 5

@export var selectionBoxSize = Vector2(60,40);
@export var selecitonBoxColor = Color.AQUA;

@export var attackDistance = 150;
@export var movementSpeed = 1;

var orbit_angle = 0
var selected = false;

var targetedObject;
var asteroids: Array;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.1
func _process(delta: float) -> void:
	queue_redraw();
	match current_state:
		states.ORBIT_LOWER:
			move_orbit(lower_orbit_radius, delta)
		states.ORBIT_UPPER:
			move_orbit(upper_orbit_radius, delta)
		states.ATTACK:
			if(asteroids.has(targetedObject)):
				print("Moving to Asteroid!")
				moveToObject();
			else:
				current_state = states.ORBIT_UPPER;
				print("Asteroid Deleted!");
		states.COLLECT:
			moveToObject(true);
			
func moveToObject(touchingObject: bool = false):
	var distx = targetedObject.position.x - position.x;
	var disty = targetedObject.position.y - position.y;
	var total_distance = (distx**2 + disty**2)**.5;
	var desiredDistance = attackDistance;
	if(touchingObject):
		desiredDistance = 0
	if(total_distance >= desiredDistance):
		var theta = atan(abs(disty)/abs(distx));
		if(distx > 0):
			position.x += movementSpeed * cos(theta);
		else:
			position.x -= movementSpeed * cos(theta);
		if(disty > 0):
			position.y += movementSpeed * sin(theta);
		else:
			position.y -= movementSpeed * sin(theta);
			

#handle instruction state change
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if selected:
				pass#print("action")

func move_orbit(orbit_ring: float, delta) -> void:
	orbit_angle += orbit_speed * delta * 60
	position = orbit_position(orbit_angle, orbit_ring)
	
func orbit_position(theta: float, radius: float) -> Vector2:
	var x =  sin(deg_to_rad(theta)) * radius
	var y = -cos(deg_to_rad(theta)) * radius
	return Vector2(x, y)
	
func attackAsteroid(asteroid):
	targetedObject = asteroid;
	current_state = states.ATTACK;
	asteroids = asteroid.get_parent().asteroids;
	print("Attacking asteroid @")
	print(asteroid.position)

func collectResource(resource):
	targetedObject = resource;
	current_state = states.COLLECT;

func _draw() -> void:
	if selected:
		draw_rect(Rect2(-selectionBoxSize / 2.0, selectionBoxSize), selecitonBoxColor, true);
