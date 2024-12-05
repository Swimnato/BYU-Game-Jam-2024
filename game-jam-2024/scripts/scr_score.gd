extends Node2D

@onready var score_label = $CanvasLayer/Score
var current_score = 0
@onready var death: Label = $CanvasLayer/Label
@onready var fs = $CanvasLayer/FinalScore


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_score() -> void:
	current_score += 1
	score_label.text = str(current_score)

func die() -> void:
	fs.text = score_label.text
	fs.visible = true
	death.visible = true
