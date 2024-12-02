extends Node2D

@onready var scn_asteroid = preload("res://scenes/scn_asteroid_large.tscn")
@onready var scene_background = $".."
@onready var width = scene_background.nativeResolution.x
@onready var height = scene_background.nativeResolution.y

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_asteroid_timer_timeout() -> void:
	var asteroid = scn_asteroid.instantiate()
	var spawn_side = rng.randi()
	var x = ((rng.randf() - 0.5) * width) if not spawn_side % 2 else (width if (spawn_side + 1) % 4 else -width)
	var y = ((rng.randf() - 0.5) * height) if spawn_side % 2 else (height if spawn_side % 4 else -height)
	asteroid.position = Vector2(x, y)
	add_child(asteroid)
