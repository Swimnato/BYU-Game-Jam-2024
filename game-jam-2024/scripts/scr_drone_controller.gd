extends Node2D

var drones: Array
@export var starting_drone_count = 5
@onready var scn_drone = preload("res://scenes/scn_drone.tscn")

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
	var angle = rng.randf() * 360
	drone.position = drone.orbit_position(angle, lower_orbit_radius)#scene_background.nativeResolution / 2
	drone.orbit_angle = angle
	drones.append(drone)
	add_child(drone)
	
