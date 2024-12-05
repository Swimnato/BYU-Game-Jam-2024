extends Node2D

@onready var score_label = $CanvasLayer/Score
var current_score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_score() -> void:
	current_score += 1
	score_label.text = str(current_score)
