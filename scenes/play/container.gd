extends Node2D

@export var normal_object: PackedScene

var spawn_positions
var target_positions

var level
var obj_index = 0
var bpm_index = 0
var time = 0.0

func _ready() -> void:
	var object_radius = GlobalConstants.OBJECT_SIZE
	
	spawn_positions = $SpawnPosition.get_children().map(func(e): return e.position)
	
	var targets_origin = $TargetPosition.get_children().map(func(e): return e.position)
	target_positions = targets_origin \
		+ targets_origin.map(func(e): return e * Vector2(-1, 1) + Vector2(object_radius, 0)) \
		+ targets_origin.map(func(e): return e + Vector2(get_viewport_rect().size.x - object_radius, 0))
	
	level = LevelData.new("test")


func _process(delta: float) -> void:
	time += delta
	while obj_index < len(level.objects) && level.objects[obj_index].time <= time:
		spawn()
		obj_index += 1


func spawn() -> void:
	var obj = normal_object.instantiate()
	obj.initialize(spawn_positions.pick_random(), target_positions.pick_random())
	add_child(obj)
