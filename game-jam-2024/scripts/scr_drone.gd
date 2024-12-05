extends Node2D

enum states { ORBIT_UPPER, ORBIT_LOWER, ATTACK, COLLECT, SENTRY }
var current_state = states.ORBIT_LOWER

@onready var controller = $".."
@onready var lower_orbit_radius = controller.lower_orbit_radius
@onready var upper_orbit_radius = controller.upper_orbit_radius

#maybe unnecessary
@onready var scene_background = $"../.."
@onready var width = scene_background.nativeResolution.x
@onready var height = scene_background.nativeResolution.y

@export var orbit_speed = 1
@export var speed = 5

@export var selectionBoxSize = Vector2(60,40);
@export var selecitonBoxColor = Color.AQUA;

@export var attackDistance = 150;
@export var movementSpeed = 200;

var orbit_angle = 0
var selected = false;

var angle = Vector2(0, 0)

var attack_target = Vector2(0, 0)

var orbit_lock_distance = 10
var sentry_orbit_lock_distance = 50
var rotation_smoothing = 0.05

var orbit_lock_smoothing = 0.01 #200 frames
var orbit_lock_lerp_acceleration = orbit_lock_smoothing
var targetedObject;
var asteroids: Array;

var sentryCoords;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.1
func _process(delta: float) -> void:
	queue_redraw();
	match current_state:
		states.ORBIT_LOWER:
			#angle = Vector2(-position.y, position.x).normalized()
			angle += (get_target_orbit_angle(Vector2(0, 0), lower_orbit_radius) - angle) * orbit_lock_lerp_acceleration # = lerp(angle, get_target_orbit_angle(Vector2(0, 0), lower_orbit_radius), orbit_lock_lerp_acceleration).normalized()
			angle = angle.normalized()
			orbit_lock_accelerate()
		states.ORBIT_UPPER:
			#angle = -1 * Vector2(-position.y, position.x).normalized()
			angle = 1 * lerp(angle, get_target_orbit_angle(Vector2(0, 0), upper_orbit_radius), orbit_lock_lerp_acceleration).normalized()
			orbit_lock_accelerate()
		states.ATTACK:
			if (attack_target - position).length() > sentry_orbit_lock_distance:
				angle += ((attack_target - position).normalized() - angle) * rotation_smoothing * delta * 60 #lerp(angle, (attack_target - position).normalized(), 0.005)
				angle = angle.normalized()
			else:
				current_state = states.SENTRY
				orbit_lock_reset()
		states.SENTRY:
			#angle = ((get_orbit_angle(attack_target, sentry_orbit_lock_distance) - angle) / orbit_lock_lerp_acceleration)
			#angle = angle.normalized()
			angle = lerp(angle, get_target_orbit_angle(attack_target, sentry_orbit_lock_distance), orbit_lock_lerp_acceleration).normalized()
			#lerp(angle, get_orbit_angle(attack_target, sentry_orbit_lock_distance), orbit_lock_lerp_acceleration).normalized()#lerp(angle, (Vector2(-(attack_target.y - position.y), attack_target.x - position.x)).normalized(), 0.05)
			orbit_lock_accelerate()
			if abs(position.length() - controller.lower_orbit_radius) < orbit_lock_distance:
				current_state = states.ORBIT_LOWER
				orbit_lock_reset()
			elif abs(position.length() - controller.upper_orbit_radius) < orbit_lock_distance:
				current_state = states.ORBIT_UPPER
				orbit_lock_reset()
			
	move(delta)

#func _physics_process(delta: float) -> void:
	#move(delta)
	#velocity = angle * speed * delta * 60
	#move_and_slide()
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
		var theta = atan(abs(disty)/abs(distx));
		if(distx > 0):
			position.x += movementSpeed * cos(theta) * delta;
		else:
			position.x -= movementSpeed * cos(theta) * delta;
		if(disty > 0):
			position.y += movementSpeed * sin(theta) * delta;
		else:
			position.y -= movementSpeed * sin(theta) * delta;

func moveToObject(delta, touchingObject: bool = false):
	var distx = targetedObject.position.x - position.x;
	var disty = targetedObject.position.y - position.y;
	var total_distance = (distx**2 + disty**2)**.5;
	var desiredDistance = attackDistance;
	if(touchingObject):
		desiredDistance = 0
	if(total_distance >= desiredDistance):
		var theta = atan(abs(disty)/abs(distx));
		if(distx > 0):
			position.x += movementSpeed * cos(theta) * delta;
		else:
			position.x -= movementSpeed * cos(theta) * delta;
		if(disty > 0):
			position.y += movementSpeed * sin(theta) * delta;
		else:
			position.y -= movementSpeed * sin(theta) * delta;
			

#handle instruction state change
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if selected:
				current_state = states.ATTACK
				var mouse_pos = get_global_mouse_position() - Vector2(width, height)
				attack_target = mouse_pos

#move forward
func move(delta) -> void:
	rotation = angle.angle()
	position += angle * speed * delta * 60
	
func get_target_orbit_angle(orbit_pos: Vector2, orbit_radius: float) -> Vector2:
	var relative_pos = position - orbit_pos
	var target_pos = relative_pos.normalized() * orbit_radius
	return Vector2(-target_pos.y, target_pos.x).normalized()

func orbit_lock_accelerate() -> void:
	if orbit_lock_lerp_acceleration <= 1.0:
		orbit_lock_lerp_acceleration += orbit_lock_smoothing
		
func orbit_lock_reset() -> void:
	orbit_lock_lerp_acceleration = orbit_lock_smoothing

#currently only used for spawning
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
	current_state = states.COLLECT;

func _draw() -> void:
	if selected:
		draw_rect(Rect2(-selectionBoxSize / 2.0, selectionBoxSize), selecitonBoxColor, true);
#unused
#func move_orbit(orbit_ring: float, delta) -> void:
	#orbit_angle += orbit_speed * delta * 60
	#position = orbit_position(orbit_angle, orbit_ring)
	#
