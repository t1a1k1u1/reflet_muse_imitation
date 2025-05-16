extends Node2D


var vector: Vector2

func initialize(spawn_pos: Vector2, target_pos: Vector2) -> void:
	vector = target_pos - spawn_pos
	
	position = spawn_pos
	rotation = atan2(vector.y, vector.x)


func _process(delta: float) -> void:
	position += vector * delta
	
	if position.x < 36 or get_viewport_rect().size.x - 36 < position.x:
		vector *= Vector2(-1, 1)


func _on_screen_exited() -> void:
	queue_free()
