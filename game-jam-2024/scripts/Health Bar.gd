extends Node2D

var centerOfBar = Vector2(0,0);
var size = Vector2(10,4);
var healthColor = Color.GREEN;
var outColor = Color.DARK_SLATE_GRAY;
var maxHealth = 100;
var currentHealth = 50;

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(centerOfBar, size), outColor, false, 10);
	var currentHealthSize: Vector2 = Vector2(currentHealth/maxHealth * size.x, size.y);
	draw_rect(Rect2(centerOfBar, size/2), healthColor, false, 10);

func setCoords(newCenter: Vector2):
	centerOfBar = newCenter;

func setSize(newSize: Vector2):
	size = newSize;

func setMaxHealth(newMaxHealth):
	maxHealth = newMaxHealth;

func setCurrentHealth(updatedHealth):
	currentHealth = updatedHealth;

func damage(amount):
	currentHealth -= amount

func heal(amount):
	currentHealth += amount
