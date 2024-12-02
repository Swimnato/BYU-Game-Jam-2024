extends Node2D

var nativeResolution = Vector2(1152, 648)
var startPos = Vector2(0,0);
var endPos = Vector2(0,0);
var isMouseDown = false;

@onready var drones = $"../droneController".drones;

var selectedDrones: Array;

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	if isMouseDown:
		endPos = convertToRelativeCoordinates(get_global_mouse_position());
		selectedDrones = findDronesInRange(startPos, endPos);

func _draw() -> void:
	if endPos != startPos:
		var size = (startPos - endPos)
		draw_rect(Rect2(endPos, size), Color.SKY_BLUE, false, 2)
	
	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			startPos = convertToRelativeCoordinates(get_global_mouse_position());
			isMouseDown = true
		elif event.is_released():
			isMouseDown = false
			startPos = Vector2(0,0)
			endPos = Vector2(0,0)

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
