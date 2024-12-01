extends Sprite2D


const AsteroidMovement = preload("res://scripts/AsteroidMovement.gd");
var movement = AsteroidMovement.new();

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_position(movement.updatePosition(position, delta * 1000));

	if position.x == position.y and position.y == 0:
		get_parent().remove_child(self)

func setPosition(newPos):
	set_position(newPos)
