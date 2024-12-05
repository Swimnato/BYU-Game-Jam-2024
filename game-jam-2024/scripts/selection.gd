extends Node2D

var nativeResolution = Vector2(1152, 648)
var startPos = Vector2(0,0);
var endPos = Vector2(0,0);
var isMouseDown = false;

const mouseMovementThreshold = 25;
const asteroidSize = Vector2(40,40);

@onready var drones = $"../droneController".drones;
@onready var asteroids = $"../asteroidController".asteroids;

@onready var lower_orbit_radius = $"../droneController".lower_orbit_radius
@onready var upper_orbit_radius = $"../droneController".upper_orbit_radius

var selectedDrones: Array;

var selectedItem;

var scraps: Array;

@onready var planet = $"../PlanetDevArt"

var selectCursor = preload("res://art/selectcursor.png");
var selectCursorHotspot = Vector2(90,65)/5/3;
var attackCursor = preload("res://art/attackcursor.png");
var attackCursorHotspot = Vector2(550/2,550/2)/5/3;
var collectCursor = preload("res://art/collectcursor.png");
var collectCursorHotspot = attackCursorHotspot;

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	if isMouseDown:
		endPos = convertToRelativeCoordinates(get_global_mouse_position());
		if(abs(endPos.x - startPos.x) > mouseMovementThreshold and abs(endPos.y - startPos.y) > mouseMovementThreshold):
			selectedDrones = findDronesInRange(startPos, endPos);
	elif(not(selectedDrones.is_empty())):
		var foundAsteroid = false;
		for asteroid in asteroids:
			if(asteroid.mouse_is_over):
				Input.set_custom_mouse_cursor(attackCursor, Input.CURSOR_ARROW, attackCursorHotspot);
				foundAsteroid = true;
		if not(foundAsteroid):
			var scrapFound = false;
			for scrap in scraps:
				if(scrap.mouse_is_over):
					Input.set_custom_mouse_cursor(collectCursor, Input.CURSOR_ARROW, collectCursorHotspot);
					scrapFound = true;
			if not(scrapFound):
				Input.set_custom_mouse_cursor(selectCursor, Input.CURSOR_ARROW, selectCursorHotspot);
	else:
		Input.set_custom_mouse_cursor(selectCursor, Input.CURSOR_ARROW, selectCursorHotspot);

func _draw() -> void:
	if endPos != startPos:
		var size = (startPos - endPos)
		draw_rect(Rect2(endPos, size), Color.SKY_BLUE, false, 2)
	if(selectedDrones.size() > 0 and isMouseDown == false):
		draw_circle(Vector2(0,0), lower_orbit_radius, Color.GREEN, false, 2);
		draw_circle(Vector2(0,0), upper_orbit_radius, Color.GREEN, false, 2);
	
	
func _input(event):
	if event is InputEventMouseButton and not planet.dead:
		if event.is_pressed():
			startPos = convertToRelativeCoordinates(get_global_mouse_position());
			isMouseDown = true
		elif event.is_released():
			isMouseDown = false
			if(abs(endPos.x - startPos.x) < mouseMovementThreshold or abs(endPos.y - startPos.y) < mouseMovementThreshold):
				if(isOverAsteroid(endPos)):
					for drone in selectedDrones:
						drone.attackAsteroid(selectedItem);
				elif(isOverScrap()):
					for drone in selectedDrones:
						drone.collectResource(selectedItem);
				elif(isOnOrbit(endPos, lower_orbit_radius)):
					for drone in selectedDrones:
						drone.current_state = drone.states.ORBIT_LOWER;
				elif(isOnOrbit(endPos, upper_orbit_radius)):
					for drone in selectedDrones:
						drone.current_state = drone.states.ORBIT_UPPER;
				else:
					for drone in selectedDrones:
						drone.standSentry(endPos);
				while(!selectedDrones.is_empty()):
					var drone = selectedDrones[0];
					drone.selected = false;
					selectedDrones.erase(drone);
			startPos = Vector2(0,0)
			endPos = Vector2(0,0)

func isOverScrap():
	for scrap in scraps:
		if(scrap.mouse_is_over):
			selectedItem = scrap;
			return true
			
func isOnOrbit(coords: Vector2, radius):
	return ((coords.x**2 + coords.y **2) ** .5 - radius) < radius / 20
			
func isOverAsteroid(coords: Vector2):
	for asteroid in asteroids:
		if asteroid.mouse_is_over:
			selectedItem = asteroid;
			return true;

func convertToRelativeCoordinates(coords) -> Vector2:
	var newX = (coords.x - (nativeResolution.x))
	var newY = (coords.y - (nativeResolution.y))
	return Vector2(newX,newY)

func findDronesInRange(corner1: Vector2, corner2: Vector2) -> Array:
	var dronesInRange: Array;
	var lowerBounds;
	var upperBounds;
	if(corner1 < corner2):
		lowerBounds = corner1;
		upperBounds = corner2;
	else:
		lowerBounds = corner2;
		upperBounds = corner1;
	for drone in drones:
		if isBetweenPoints(lowerBounds, upperBounds, drone.position):
			drone.selected = true;
			dronesInRange.append(drone);
		else:
			drone.selected = false;
	return dronesInRange;


func isBetweenPoints( corner1: Vector2, corner2: Vector2, coords: Vector2 ):
	var isBetween = true;
	if(not((coords.x < corner1.x and coords.x > corner2.x) or (coords.x > corner1.x and coords.x < corner2.x))):
		isBetween = false;
	if(not((coords.y < corner1.y and coords.y > corner2.y) or (coords.y > corner1.y and coords.y < corner2.y))):
		isBetween = false;
	return isBetween;
