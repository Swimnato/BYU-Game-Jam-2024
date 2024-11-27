extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var zoomage = Vector2(.5, .5)
	$Camera2D.zoom = zoomage


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
