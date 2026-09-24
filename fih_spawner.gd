extends Node3D

var fish_scene = preload("res://Fih/fih.tscn")
var school_quantity: int = 20 # amount of fish spawned
var spawn_radius: float = 1.75 

var fih_coords: Array[Vector3] = []
var fih_distance: float = 0
var isok: bool = 1
var c: int = 0;


func _ready():
	for i in range(school_quantity):
		var new_fish = fish_scene.instantiate()
		add_child(new_fish)
		
		while true:
			isok = 1
			new_fish.position = Vector3( # spawns fish to random location in range
				randf_range(-spawn_radius, spawn_radius),
				randf_range(-spawn_radius, spawn_radius),
				randf_range(-spawn_radius, spawn_radius)
			)
			if c == 0: # if is first fish don't check anything just go
				break
			for coords in fih_coords: #checks if has another fish nearby
				fih_distance = sqrt(pow(coords[0]-new_fish.position[0],2)+pow(coords[1]-new_fish.position[1],2)+pow(coords[2]-new_fish.position[2],2))
				if fih_distance < 1.25: # don't increase this value too much or it will crash
					isok = 0 
			if isok:
				break
		fih_coords.append(new_fish.position) # saves approved fish locations to an array that's checked every time a fish spawns
		c += 1
		
