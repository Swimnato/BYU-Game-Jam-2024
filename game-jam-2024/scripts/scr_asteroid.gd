extends Node2D

var rng = RandomNumberGenerator.new()

enum types { SMALL, MEDIUM, LARGE }
var current_type = types.LARGE

@onready var controller = $".."

@export var min_speed = 1.0
@export var max_speed = 2.0
@export var thresholdAroundPlanet = 50;

@export var maxHP = 100;
var hp = maxHP;

@onready var angle: Vector2 = (position * -1).normalized()
var speed = rng.randf_range(min_speed, max_speed)

@onready var healthBar = $Status_Bars;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthBar.setMaxHealth(maxHP);
	healthBar.setCoords(Vector2(0, 50));

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	healthBar.setCurrentHealth(hp);
	move(delta)

func move(delta: float) -> void:
	position += angle * speed * delta * 60
