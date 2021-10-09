extends Spatial

onready var body = get_node("RigidBody")
onready var camera_gimble = get_node("CameraGimble")
onready var floor_collider = get_node("FloorCollider")

var floor_contacts := 0

var new_max_vel = 0.0
var new_min_vel = 10000.0
var median_vel = []

var force = 0.0
var on_the_ground = false

func _process(_delta):
	
	camera_gimble.translation = body.translation
	
	if Input.is_action_pressed("jump"):
		jump()
		
func _physics_process(_delta):
	if body.linear_velocity.x <= 10:
		force += 0.2
	else:
		force = 0.0
		
	body.add_central_force(Vector3(force, 0, 0))
	
	on_the_ground = floor_contacts
#	if not on_the_ground : print(on_the_ground)


func jump():
	if not on_the_ground:
		return
	else:
		body.linear_velocity.y = 20.0
		body.angular_velocity.z = -4.0


func _on_FloorCollider_body_entered(body):
	print("Touched Something")
	if body.is_in_group("floor"):
		print("Touched floor")
		floor_contacts += 1


func _on_FloorCollider_body_exited(body):
	print("Left Something")
	if body.is_in_group("floor"):
		print("Left floor")
		floor_contacts -= 1
