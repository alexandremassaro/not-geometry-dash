extends Spatial

onready var body = get_node("RigidBody")
onready var camera_gimble = get_node("CameraGimble")

#func _input(event):	
#	if event.is_action_pressed("jump") and is_on_floor():
#		jump()
var force = 0.0

func _process(delta):
	
	camera_gimble.translation = body.translation
	
	if Input.is_action_pressed("jump"):
		jump()
		
func _physics_process(delta):
#	if body.linear_velocity.x > 10:
#		force -= 0.1
#	elif body.linear_velocity.x < 10:
#		force += 0.1
#	else:
#		force = 0.0
#	body.add_central_force(Vector3(force, 0, 0))
	
	print("Acceleration : " + String(force) + " Velocity: " + String(body.linear_velocity.x))

#func _physics_process(delta):
#	velocity.y += GRAVITY * delta
#	velocity.x = SPEED
#	print(is_on_floor())
#
#	velocity = move_and_slide(velocity, Vector3.UP)


func jump():
	
	if body.linear_velocity.y <= 1.0 and body.linear_velocity.y >= -1.0:
		body.linear_velocity.y = 20.0
		body.angular_velocity.z = -4.0
