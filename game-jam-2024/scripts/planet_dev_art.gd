extends Sprite2D

@export var max_hp = 100
@export var damage_tick = 5
var current_hp = max_hp

@onready var healthBar = $Status_Bars;
@onready var asteroids = $"../asteroidController".asteroids;

var planet_broken = preload("res://art/planet_megabroken.png");
var planet_hurt = preload("res://art/planet_hurt.png");
var planet_flashing = preload("res://art/planet_healthy_flash.png");
var planet_idle = [preload("res://art/planet_healthy_1.png"), preload("res://art/planet_healthy_2.png"), preload("res://art/planet_healthy_3.png"), preload("res://art/planet_healthy_2.png")];
var currentFrame = 0;
@export var timeForEachFrame = .5;
var timeSinceLastFrameChange = 0;
var lastFlash = 0;
var rotationsForFlash = 7;

@onready var score = $"../ScnScore"

var dead = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x = 0
	position.y = 0
	healthBar.setMaxHealth(max_hp);
	healthBar.setMainColor(Color.GREEN);
	healthBar.setCoords(Vector2(0,350));
	healthBar.size = healthBar.size * 4;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	healthBar.setCurrentHealth(current_hp);
	if(current_hp > max_hp/3*2):
		timeSinceLastFrameChange += delta;
		if(timeSinceLastFrameChange > timeForEachFrame):
			timeSinceLastFrameChange = 0;
			currentFrame += 1;
			if(currentFrame >= planet_idle.size()):
				currentFrame = 0;
			if(currentFrame % 2 == 1):
				lastFlash += 1;
		if(lastFlash >= rotationsForFlash):
			texture = planet_flashing;
			lastFlash = 0;
		else:
			texture = planet_idle[currentFrame];
	elif(current_hp > max_hp/3):
		texture = planet_hurt;
	else:
		texture = planet_broken;
	#pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name.begins_with("Asteroid_Area"):
		asteroids.erase(area.get_parent().get_parent());
		area.get_parent().get_parent().queue_free();
		take_damage(damage_tick)

func take_damage(dmg: float) -> void:
	current_hp -= dmg
	if current_hp <= 0:
		score.die()
		dead = true;
