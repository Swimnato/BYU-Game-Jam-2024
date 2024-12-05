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
@export var movementSpeed = 200;

@onready var statusBar = $Status_Bars;

var orbit_angle = 0
var selected = false;

var targetedObject;
var asteroids: Array;

var sentryCoords;

@export var maxEnergy = 100;
@export var rechargeRate = 20;
var energy = 30;



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	statusBar.setMainColor(Color.AQUA);
	statusBar.setBkgColor(Color.DARK_SLATE_BLUE);
	statusBar.setCoords(Vector2(-50,0));
	statusBar.rotate90();
	statusBar.setMaxHealth(maxEnergy);

# Called every frame. 'delta' is the elapsed time since the previous frame.1
func _process(delta: float) -> void:
	statusBar.setCurrentHealth(energy);
	queue_redraw();
	match current_state:
		states.ORBIT_LOWER:
			move_orbit(lower_orbit_radius, delta)
			energy += delta * rechargeRate;
		states.ORBIT_UPPER:
			move_orbit(upper_orbit_radius, delta)
		states.ATTACK:
			if(asteroids.has(targetedObject)):
				moveToObject(delta);
			else:
				current_state = states.ORBIT_UPPER;
		states.COLLECT:
			moveToObject(delta, true);
		states.SENTRY:
			moveToCoords(delta, sentryCoords);
			
func moveToCoords(delta, coords: Vector2):
	var distx = coords.x - position.x;
	var disty = coords.y - position.y;
	var total_distance = (distx**2 + disty**2)**.5;
	if(total_distance < movementSpeed * delta):
		position.x = coords.x;
		position.y = coords.y;
	else:
		var theta = atan2(disty,distx);
		rotation = theta
		position += movementSpeed * Vector2(cos(theta), sin(theta)) * delta


func moveToObject(delta, touchingObject: bool = false):
	var distx = targetedObject.position.x - position.x
	var disty = targetedObject.position.y - position.y
	var total_distance = (distx**2 + disty**2)**.5;
	var desiredDistance = attackDistance;
	if(touchingObject):
		desiredDistance = 0
	if(total_distance >= desiredDistance):
		var theta = atan2(disty,distx);
		rotation = theta
		position += movementSpeed * Vector2(cos(theta), sin(theta)) * delta
		

#handle instruction state change
#func _input(event):
	#if event is InputEventMouseButton:
		#if event.is_pressed():
			#if selected:
				#pass#print("action")

func move_orbit(orbit_ring: float, delta) -> void:
	orbit_angle += orbit_speed * delta * 60
	var pos = orbit_position(orbit_angle, orbit_ring)
	position = pos
	rotation = Vector2(-pos.y, pos.x).angle()
	
func orbit_position(theta: float, radius: float) -> Vector2:
	var x =  sin(deg_to_rad(theta)) * radius
	var y = -cos(deg_to_rad(theta)) * radius
	return Vector2(x, y)
	
func standSentry(coords: Vector2):
	sentryCoords = coords;
	current_state = states.SENTRY;
	
func attackAsteroid(asteroid):
	targetedObject = asteroid;
	current_state = states.ATTACK;
	asteroids = asteroid.get_parent().asteroids;

func collectResource(resource):
	targetedObject = resource;
	current_state = states.COLLECT

func _draw() -> void:
	if selected:
		draw_rect(Rect2(-selectionBoxSize / 2.0, selectionBoxSize), selecitonBoxColor, true);
