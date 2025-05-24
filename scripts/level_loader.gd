class_name LevelLoader

# {
# 	"info": {
# 		"title": "曲名",
# 		"artist": "作曲者",
# 		"bpm": "BPM (表記)"
# 	},
# 	"bpm_events": [
# 		{
# 			"pulse": 0,
# 			"bpm": 200
# 		}
# 	],
# 	"objects": [
# 		{
# 			"type": "normal",
# 			"pulse": 500
# 		},
# 		{
# 			"type": "long",
# 			"pulse": 1000,
# 			"pulse_end": 1200
# 		},
# 		{
# 			"type": "chain",
# 			"pulse": 1500,
# 			"chained": [
# 				{
# 					"pulse": 1600
# 				}
# 			]
# 		}
# 	]
# }

const resolution: float = 64 # pulse / beat

var bpm_events: Array[BpmEvent]
var objects: Array[Obj]

func _init(level_name: String) -> void:
	var raw_data = loadFile("res://levels/%s.json" % level_name)
	
	if raw_data == null:
		printerr("Load Level Error")


func loadFile(file_path: String) -> Variant:
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if file:
		var json_text = file.get_as_text()
		var json_parsed = JSON.parse_string(json_text)
		file.close()
		
		if json_parsed:
			return json_parsed
		else:
			printerr("JSON Parse Error")
	else:
		printerr("File Open Error")
	
	return null


func loadBpmEvents(events: Array[Dictionary]) -> void:
	events.sort_custom(func(a, b): return a["pulse"] < b["pulse"])
	
	var pulse: int = 0
	var bpm: float = 0
	var time: float = 0
	for event in events:
		var next_pulse = event["pulse"]
		var next_bpm = event["bpm"]
		var next_time = time + (bpm / 60.0 / resolution) * (next_pulse - pulse)
		
		pulse = next_pulse
		bpm = next_bpm
		time = next_time
		
		bpm_events.push_back(BpmEvent.new(pulse, bpm, time))


func loadObjects(objects: Array[Dictionary]) -> void:
	objects.sort_custom(func(a, b): return a["pulse"] < b["pulse"])
	
	var bpm_index = 0
	
	for object in objects:
		var next_pulse = object["pulse"]
		
		var has_next_bpm = len(bpm_events) - 1 < bpm_index
		if has_next_bpm && bpm_events[bpm_index + 1].pulse <= next_pulse:
			bpm_index += 1
		
		var current_bpm = bpm_events[bpm_index]
		
		var pulse_time = current_bpm.bpm / 60.0 / resolution
		var next_time = current_bpm.time + pulse_time * (next_pulse - current_bpm.pulse)
		
		if object["type"] == "normal":
			objects.push_back(Obj.new(next_time))
		
		elif object["type"] == "long":
			var end_time = current_bpm.time + pulse_time * (object["pulse_end"] - current_bpm.pulse)
			objects.push_back(LongObj.new(next_time, end_time))
		
		elif object["type"] == "chain":
			var chained = (object["chained"] as Array).map(func(e): return Obj.new(current_bpm.time + pulse_time * (e["pulse"] - current_bpm.pulse)))
			objects.push_back(ChainObj.new(next_time, chained))


class Obj:
	var time: float
	
	func _init(time: float) -> void:
		self.time = time

class LongObj extends Obj:
	var time_end: int
	
	func _init(time: float, time_end: float) -> void:
		super(time)
		self.time_end = time_end

class ChainObj extends Obj:
	var chained: Array[Obj]
	
	func _init(time: float, chained: Array[Obj]) -> void:
		super(time)
		self.chained = chained

class BpmEvent:
	var pulse: int
	var time: float
	var bpm: float
	
	func _init(pulse: int, bpm: float, time: float) -> void:
		self.pulse = pulse
		self.bpm = bpm
		self.time = time 
