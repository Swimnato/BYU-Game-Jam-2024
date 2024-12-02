extends Sprite2D

@export var max_hp = 100
@export var damage_tick = 5
var current_hp = max_hp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x = 0
	position.y = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name.begins_with("Asteroid_Area"):
		area.get_parent().queue_free()
		take_damage(damage_tick)

func take_damage(dmg: float) -> void:
	current_hp -= dmg
