extends Node3D

@export var forward_speed: float = 4   # the fish goes forward with a constant speed
@export var turn_speed: float = 2      # how fast the fish turns
@export var turn_forward_speed: float = 1 # the forward speed when turning
@export var roam_distance: float = 3.5   # distance from its spawn point (home)

var home_position: Vector3
var target_yaw: float = 0.0
var timer: float = 0.0
var flip: bool = false;
var speed: float = forward_speed

func odd_even(n):
	if n%2 == 0:
		return 1
	else: return -1



func _ready():
	home_position = global_position
	speed *= randf_range(0.75, 1.25) # gives fishes a randomized speed to make
									 # the acquarium more alive

func _physics_process(delta):
	timer += delta
	var distance_from_home = global_position.distance_to(home_position)
	
	if distance_from_home > roam_distance && !flip:
		target_yaw = (target_yaw + PI) # 180° turn
		
		rotation.y += 0.001 # is needed to make the lerp_angle() turn always in one direction
							# otherwise the fish gets further and further away with no return
							
		flip = true # stops the code from adding PI for too many times when outside the home range
		
		speed = lerp(speed,turn_forward_speed, 0.75) # slows down the fish when turning to make it less robotic
	
	elif distance_from_home < roam_distance: 
		flip = false
		speed = lerp(speed,forward_speed, delta) # speeds up the fish to its original speed
	elif timer > randf_range(3.0, 8.0) && !flip: # the fish can turn before it reaches the limit of the home range
		target_yaw = (target_yaw + PI)
		rotation.y += 0.001
		timer = 0.0
	
	rotation.y = lerp_angle(rotation.y, target_yaw, turn_speed * delta) # actual rotation
	
	var forward_direction = -global_transform.basis.x
	global_position += forward_direction * speed * delta # actual forward movement
