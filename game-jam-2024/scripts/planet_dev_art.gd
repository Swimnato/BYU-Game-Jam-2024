extends Sprite2D

@export var max_hp = 100
@export var damage_tick = 5
@export var current_hp = max_hp

@onready var healthBar = $Status_Bars;
@onready var asteroids = $"../asteroidController".asteroids;

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
	#pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name.begins_with("Asteroid_Area"):
		asteroids.erase(area.get_parent().get_parent());
		area.get_parent().get_parent().queue_free();
		take_damage(damage_tick)

func take_damage(dmg: float) -> void:
	current_hp -= dmg
