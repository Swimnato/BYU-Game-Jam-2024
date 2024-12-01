extends Sprite2D

var nativeResolution = Vector2(1152, 648)
var scaleForNativeResolution = Vector2(.5, .5)
var currentResolution = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fitWindow(nativeResolution)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fitWindow(get_window().get_size())

func fitWindow(newResolution):
	if newResolution.x != currentResolution.x or newResolution.y != currentResolution.y:
		currentResolution = newResolution
		var x_zoom = currentResolution.x/nativeResolution.x * scaleForNativeResolution.x
		var y_zoom = currentResolution.y/nativeResolution.y * scaleForNativeResolution.y
		if(x_zoom != y_zoom):
			if(x_zoom < y_zoom):
				y_zoom = x_zoom
			else:
				x_zoom = y_zoom
		var zoomage = Vector2(x_zoom, y_zoom)
		$Camera2D.zoom = zoomage
