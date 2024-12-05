extends Node2D

enum states { ORBIT_UPPER, ORBIT_LOWER, ATTACK, COLLECT, SENTRY }
var current_state = states.ORBIT_LOWER

@onready var controller = $".."
@onready var lower_orbit_radius = controller.lower_orbit_radius
@onready var upper_orbit_radius = controller.upper_orbit_radius

@export var orbit_speed = 1
@export var attack_speed = 5

@export var selectionBoxSize = Vector2(80,90);
@export var selecitonBoxColor = Color.AQUA;

@export var attackDistance = 150;
@export var movementSpeed = 200;

@onready var statusBar = $Status_Bars;

var orbit_angle = 0
var selected = false;

var targetedObject;
@onready var asteroids: Array = get_parent().asteroids;

var inRangeOfAteroid = false;

var sentryCoords;

@export var attackDamage = 10;
@export var attackRate = 500;
@export var laserColor = Color.TEAL;
@export var agroRange = 250;
var lastAttack = 0;

@export var maxEnergy = 100;
@export var rechargeRate = 20;
@export var dischargeRate = 5;
@export var attackEnergy = 5;
var energy = maxEnergy;

var rechargingFrame = preload("res://art/RAYchargingbattery.png");
var chargingLaserFrame = preload("res://art/chargedRAYdrone.png");
var firingLaserFrame = preload("res://art/chargedRAYdrone2.png");
var idle: Array = [preload("res://art/RAYidle1.png"), preload("res://art/RAYidle2.png"), preload("res://art/RAYidle3.png"), preload("res://art/RAYidle2.png")];
var currentIdle = 0;
@export var timeOnEachFrame = .33;
var timeSinceLastFrameChange = 0;

@onready var image = $Drone;



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
	image.texture = idle[currentIdle];
	if energy > 0:
		timeSinceLastFrameChange += delta;
		if(timeSinceLastFrameChange >= timeOnEachFrame):
			currentIdle += 1;
			timeSinceLastFrameChange = 0;
		if(currentIdle >= idle.size()):
			currentIdle = 0;
		match current_state:
			states.ORBIT_LOWER:
				image.texture = rechargingFrame;
				inRangeOfAteroid = false
				move_orbit(lower_orbit_radius, delta)
				energy += delta * rechargeRate;
				
			states.ORBIT_UPPER:
				inRangeOfAteroid = false
				move_orbit(upper_orbit_radius, delta)
				targetNearbyAsteroids()
			states.ATTACK:
				if(asteroids.has(targetedObject)):
					moveToObject(delta);
				else:
					inRangeOfAteroid = false
					current_state = states.ORBIT_UPPER;
				if(inRangeOfAteroid):
					lastAttack += delta * 1000;
					if(lastAttack >= attackRate):
						damageAsteroid();
					if(lastAttack >= attackRate / 3 * 2):
						image.texture = firingLaserFrame;
					elif(lastAttack >= attackRate / 3):
						image.texture = chargingLaserFrame;
					
			states.COLLECT:
				inRangeOfAteroid = false;
				moveToObject(delta, true);
			states.SENTRY:
				targetNearbyAsteroids();
				inRangeOfAteroid = false
				moveToCoords(delta, sentryCoords);
	
	if(energy > maxEnergy):
		energy = maxEnergy;
	if(energy < 0):
		energy = 0;
		

func targetNearbyAsteroids():
	for asteroid in asteroids:
		var distance = (asteroid.position - position).length();
		if(distance <= agroRange):
			attackAsteroid(asteroid);

func damageAsteroid():
		targetedObject.damage(attackDamage);
		lastAttack = 0;
		energy -= attackEnergy;
			
func moveToCoords(delta, coords: Vector2):
	var distx = coords.x - position.x;
	var disty = coords.y - position.y;
	var total_distance = (distx**2 + disty**2)**.5;
	var theta = atan2(disty,distx);
	rotation = theta
	if(total_distance < movementSpeed * delta):
		position.x = coords.x;
		position.y = coords.y;
		energy += delta * dischargeRate * total_distance / movementSpeed;
	else:
		
		position += movementSpeed * Vector2(cos(theta), sin(theta)) * delta
		energy -= delta * dischargeRate


func moveToObject(delta, touchingObject: bool = false):
	var distx = targetedObject.position.x - position.x
	var disty = targetedObject.position.y - position.y
	var total_distance = (distx**2 + disty**2)**.5;
	var desiredDistance = attackDistance;
	var theta = atan2(disty,distx);
	rotation = theta
	if(total_distance > desiredDistance):
		inRangeOfAteroid = false;
		position += movementSpeed * Vector2(cos(theta), sin(theta)) * delta
		energy -= delta * dischargeRate
	else:
		inRangeOfAteroid = true;
		if(total_distance < desiredDistance - 10):
			position -= movementSpeed * Vector2(cos(theta), sin(theta)) * delta
			energy -= delta * dischargeRate
		

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

func collectResource(resource):
	targetedObject = resource;
	current_state = states.COLLECT

func _draw() -> void:
	if selected:
		draw_rect(Rect2(-selectionBoxSize / 2.0, selectionBoxSize), selecitonBoxColor, true);
	if inRangeOfAteroid and targetedObject != null:
		if(lastAttack >= attackRate / 3 * 2):
			var distx = targetedObject.position.x - position.x
			var disty = targetedObject.position.y - position.y
			var total_distance = (distx**2 + disty**2)**.5;
			draw_rect(Rect2(Vector2(30, -5), Vector2(total_distance, 10)), laserColor, true);
