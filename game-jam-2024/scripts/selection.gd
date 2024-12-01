extends Node2D

var nativeResolution = Vector2(1152, 648)
var startPos = Vector2(0,0);
var endPos = Vector2(0,0);
var isMouseDown = false

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if isMouseDown:
		endPos = convertToRelativeCoordinates(get_global_mouse_position());
	if endPos != startPos:
		var size = (startPos - endPos)
		draw_rect(Rect2(endPos, size), Color.SKY_BLUE, false, 10)
	
	
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
