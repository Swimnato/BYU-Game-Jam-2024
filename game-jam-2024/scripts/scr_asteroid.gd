extends Node2D

var rng = RandomNumberGenerator.new()

enum types { SMALL, MEDIUM, LARGE }
var current_type = types.LARGE

@onready var controller = $".."

@export var min_speed = 1.0
@export var max_speed = 2.0
@export var thresholdAroundPlanet = 200;

@onready var angle: Vector2 = (position * -1).normalized()
var speed = rng.randf_range(min_speed, max_speed)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)
	if abs(position.x) < thresholdAroundPlanet  and abs(position.y) < thresholdAroundPlanet:
		#deal damage to planet
		get_parent().asteroids.erase(self);
		get_parent().remove_child(self)

func move(delta: float) -> void:
	position += angle * speed * delta * 60
