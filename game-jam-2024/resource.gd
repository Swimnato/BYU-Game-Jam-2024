extends Node2D

var mouse_is_over = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	mouse_is_over = true;

func _on_area_2d_mouse_exited() -> void:
	mouse_is_over = false;

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "DroneArea":
		get_parent().scraps.erase(self);
		get_parent().get_parent().find_child("droneController").create_drone();
		self.queue_free();
