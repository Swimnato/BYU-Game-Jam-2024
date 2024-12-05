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

@export var textures: Array

@export var scale_variance = 1.0

var mouse_is_over = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthBar.setMaxHealth(maxHP);
	healthBar.setCoords(Vector2(0, 50));
	rotation = rng.randf() * 360
	$Sprite2D.texture = textures[randi() % textures.size()]
	scale.x += randf() * scale_variance
	scale.y += randf() * scale_variance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	healthBar.setCurrentHealth(hp);
	move(delta)
	if hp <= 0:
		get_parent().asteroids.erase(self);
		self.queue_free();

func damage(amount: int = 10):
	hp -= amount;

func move(delta: float) -> void:
	position += angle * speed * delta * 60
	


func _on_asteroid_area_mouse_entered() -> void:
	mouse_is_over = true


func _on_asteroid_area_mouse_exited() -> void:
	mouse_is_over = false
