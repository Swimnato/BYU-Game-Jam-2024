extends Node2D

enum states { ORBIT_UPPER, ORBIT_LOWER, ATTACK, COLLECT, SENTRY }
var current_state = states.ORBIT_LOWER

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
