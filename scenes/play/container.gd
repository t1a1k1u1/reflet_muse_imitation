extends Node2D

@export var normal_object: PackedScene


func _ready() -> void:
	var spawn_pos = $SpawnPosition.get_children().pick_random().position
	var target_pos = $TargetPosition.get_children().pick_random().position
	var obj = normal_object.instantiate()
	
	obj.initialize(spawn_pos, target_pos)
	add_child(obj)
