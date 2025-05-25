extends Node2D

var normal_object = preload("res://scenes/object/normal_object.tscn")

func initialize(spawn_pos: Vector2, target_pos: Vector2, times: Array) -> void:
	times.reverse()
	for time in times:
		var obj = normal_object.instantiate()
		obj.initialize(spawn_pos, target_pos, time)
		add_child(obj)
