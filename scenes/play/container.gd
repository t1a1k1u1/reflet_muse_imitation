extends Node2D

@export var normal_object: PackedScene
@onready var chain_object = preload("res://scenes/object/chain_object.tscn")
@onready var long_object = preload("res://scenes/object/long_object.tscn")

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
	while obj_index < len(level.objects) && level.objects[obj_index].time <= time + 2.0:
		spawn(level.objects[obj_index], time)
		obj_index += 1


func spawn(object, time: float) -> void:
	if object.type == "normal":
		var obj = normal_object.instantiate()
		obj.initialize(spawn_positions.pick_random(), target_positions.pick_random(), object.time - time)
		add_child(obj)
	
	elif object.type == "chain":
		var obj = chain_object.instantiate()
		var times = [object.time - time] + object.chained.map(func(e): return e - time)
		obj.initialize(spawn_positions.pick_random(), target_positions.pick_random(), times)
		add_child(obj)
	
	elif object.type == "long":
		var obj = long_object.instantiate()
		var time_start = object.time - time
		var time_end = object.time_end - time
		obj.initialize(spawn_positions.pick_random(), target_positions.pick_random(), time_start, time_end)
		add_child(obj)
