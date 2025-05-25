extends Node2D

var vector: Vector2
var radius = GlobalConstants.OBJECT_SIZE / 2
var speed
var tail_stop_time: float = 0.0
var tail_stop_remain: float = 0.0

func initialize(spawn_pos: Vector2, target_pos: Vector2, time: float, time_end: float) -> void:
	vector = target_pos - spawn_pos
	
	$Head.position = spawn_pos
	$Tail.position = spawn_pos
	$Head.rotation = atan2(vector.y, vector.x)
	$Tail.rotation = atan2(vector.y, vector.x)
	
	speed = 1.0 / time
	tail_stop_time = time_end - time


func _process(delta: float) -> void:
	$Head.position += vector * delta * speed
	
	if 0.0 < tail_stop_remain:
		tail_stop_remain -= delta
	else:
		$Tail.position += vector * delta * speed
	
	if $Head.position.x < radius or get_viewport_rect().size.x - radius < $Head.position.x:
		vector *= Vector2(-1, 1)
		tail_stop_remain = tail_stop_time
	
	$Chain.clear_points()
	$Chain.add_point($Head.position)
	$Chain.add_point($Tail.position)


func _on_screen_exited() -> void:
	queue_free()
