extends Node3D

# there are two cameras, one frames another acquarium
@onready var cam1 = $Camera1
@onready var cam2 = $Camera2


# it is possible to make it switch between the two, was an idea but I don't use it
@export var setcam: bool = false
@export var switch_time: float = 10.0 
var timer: float = 0.0

func _ready():
	# i force the cam2 but this can be changed
	if setcam: 
		cam1.make_current()
	else: 
		cam2.make_current()
		

func _input(event): # this closes the savescreen if you oress any key or mousebutton 
	if true: # put false if you don't want it to be a savescreen
		if event is InputEventKey or event is InputEventMouseButton:# or event is InputEventMouseMotion:
			get_tree().quit()										# the mouse movement is bugged and closes it immediately

func _process(delta):
	if setcam:
		timer += delta
		# switches cam when timer runs out
		if timer >= switch_time:
			timer = 0.0 
			
			if cam1.current == true:
				cam2.make_current()
			else:
				cam1.make_current()
