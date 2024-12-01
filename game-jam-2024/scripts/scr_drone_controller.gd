extends Node2D

var drones: Array[PackedScene]
@export var starting_drone_count = 5
@onready var scn_drone = preload("res://scenes/scn_drone.tscn")
@onready var scene_background = $".."

@export var lower_orbit_radius = 225
@export var upper_orbit_radius = 350

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(starting_drone_count):
		create_drone()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func create_drone() -> void:
	var drone = scn_drone.instantiate()
	drone.position = orbit_position(rng.randf() * 360, lower_orbit_radius)#scene_background.nativeResolution / 2
	drones.append(drone)
	add_child(drone)
	
func orbit_position(theta: float, radius: float) -> Vector2:
	var x = sin(theta/180.0 * PI) * radius
	var y = -cos(theta/180.0 * PI) * radius
	return Vector2(x, y)
