extends Node2D

@export var centerOfBar = Vector2(0,0);
@export var size = Vector2(50,10);
@export var healthColor = Color.GREEN;
@export var outColor = Color.DARK_SLATE_GRAY;
@export var maxHealth = 100;
@export var currentHealth = 0;

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(currentHealth > maxHealth):
		currentHealth = maxHealth;
	elif(currentHealth < 0):
		currentHealth = 0;
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(centerOfBar, size), outColor, true, 1);
	var currentHealthSize: Vector2 = Vector2(1.0 * currentHealth/maxHealth * size.x, size.y);
	if(currentHealth > 0):
		draw_rect(Rect2(centerOfBar, currentHealthSize), healthColor, true, 1);

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
