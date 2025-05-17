extends Node2D

var vector: Vector2
var radius = GlobalConstants.OBJECT_SIZE / 2

func initialize(spawn_pos: Vector2, target_pos: Vector2) -> void:
	vector = target_pos - spawn_pos
	
	position = spawn_pos
	rotation = atan2(vector.y, vector.x)


func _process(delta: float) -> void:
	position += vector * delta
	
	if position.x < radius or get_viewport_rect().size.x - radius < position.x:
		vector *= Vector2(-1, 1)


func _on_screen_exited() -> void:
	queue_free()
