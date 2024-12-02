extends Sprite2D

@export var spriteList: Array[Texture2D];
var i = 0;
@export var flash: Texture2D;
@export var timeBetweenFrames = 0.5;
@export var chance = 0.25;

var rng = RandomNumberGenerator.new()
# @onready var planetSprite = $Planet/PlanetSprite;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = spriteList[i];


# Called every frame. 'delta' is the elapsed time since the previous frame.
var timeSinceLastFrame = 0.0;
func _process(deltaTime: float) -> void:
	timeSinceLastFrame += deltaTime;
	if(timeSinceLastFrame >= timeBetweenFrames):
		if (i == spriteList.size()):
			var my_random_number = rng.randf_range(0.0,1.0)
			if(my_random_number <= chance):
				texture = flash;
			i=0;
		elif (i >= spriteList.size()):
			i = 0;
		else:
			texture = spriteList[i];
			i += 1;
		

		timeSinceLastFrame = 0.0;
