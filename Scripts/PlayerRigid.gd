extends Spatial

var is_on_ground := true

func _physics_process(delta):
	if Input.is_action_pressed("jump") and is_on_ground:
		$RigidBody.add_central_force(Vector3(0, 100.0, 0))


func _on_FloorCollider_body_entered(body):
	if body.is_in_group("floor"):
		is_on_ground = true
		print(is_on_ground)


func _on_FloorCollider_body_exited(body):
	if body.is_in_group("floor"):
		is_on_ground = false
		print(is_on_ground)
