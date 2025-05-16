extends Node2D

@export var normal_object: PackedScene

var spawn_positions
var target_positions


func _ready() -> void:
	spawn_positions = $SpawnPosition.get_children().map(func(e): return e.position)
	
	var targets_origin = $TargetPosition.get_children().map(func(e): return e.position)
	target_positions = targets_origin \
		+ targets_origin.map(func(e): return e * Vector2(-1, 1)) \
		+ targets_origin.map(func(e): return e + Vector2(get_viewport_rect().size.x, 0))
	
	var obj = normal_object.instantiate()
	
	obj.initialize(spawn_positions.pick_random(), target_positions.pick_random())
	add_child(obj)
