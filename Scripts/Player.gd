extends KinematicBody
class_name Player

signal player_died

onready var camera_gimble = get_node("CameraGimble")
onready var camera : Camera = get_node("CameraGimble/Camera")

const ORTH_CAMERA_SIZE = 15.0
const ORTH_H_OFFSET = 3.0
const ORTH_V_OFFSET = 2.0
const ORTH_CAMERA_ROTATION = 0.0

const PERSP_CAMERA_DISTANCE = 5.0
const PERSP_H_OFFSET = 0.0
const PERSP_V_OFFSET = 1.0
const PERSP_CAMERA_ROTATION = -90.0

const CAMERA_INTERPOLATION_SPEED = 0.5

const FORWARD_DIRECTION := Vector3.RIGHT
const JUMP_LINEAR_VELOCITY = 13.8
const JUMP_ANGULAR_VELOCITY = -2.0
const GRAVITY_MULTIPLIER = 5.0

const MAX_SPEED = 10.0

var gravity_magnitude : float = ProjectSettings.get_setting("physics/3d/default_gravity")

var velocity := Vector3.ZERO
var snap_vector := Vector3.ZERO


func _ready():
	camera.size = ORTH_CAMERA_SIZE
	camera.h_offset = ORTH_H_OFFSET
	camera.v_offset = ORTH_V_OFFSET


func _input(event):
	if event.is_action_pressed("change_perspective"):
		change_perpective()


func _physics_process(delta):
#	apply_movement()
#	apply_gravity(delta)
#	update_snap_vector()
	jump()
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector3.UP)


func apply_movement():
	velocity.x = MAX_SPEED


func apply_gravity(delta):
	velocity.y += -gravity_magnitude * GRAVITY_MULTIPLIER * delta
	velocity.y = clamp(velocity.y, -gravity_magnitude * GRAVITY_MULTIPLIER, JUMP_LINEAR_VELOCITY)


func update_snap_vector():
#	snap_vector = -get_floor_normal() if is_on_floor() else Vector3.DOWN
	snap_vector = Vector3.DOWN
	

func jump():
	if Input.is_action_pressed("jump") and is_on_floor():
		snap_vector = Vector3.ZERO
		velocity.y = JUMP_LINEAR_VELOCITY


func change_perpective():
	
	var gimble_tween : Tween = get_node("CameraGimble/GimbleTween")
	var camera_tween : Tween = get_node("CameraGimble/Camera/CameraTween")
	
	if camera.projection == Camera.PROJECTION_ORTHOGONAL:
		camera.set_projection(Camera.PROJECTION_PERSPECTIVE)
# warning-ignore:return_value_discarded
		gimble_tween.interpolate_property(camera_gimble, "rotation_degrees:y", ORTH_CAMERA_ROTATION, PERSP_CAMERA_ROTATION, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
# warning-ignore:return_value_discarded
		camera_tween.interpolate_property(camera, "h_offset", ORTH_H_OFFSET, PERSP_H_OFFSET, CAMERA_INTERPOLATION_SPEED, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
# warning-ignore:return_value_discarded
		camera_tween.interpolate_property(camera, "v_offset", ORTH_V_OFFSET, PERSP_V_OFFSET, CAMERA_INTERPOLATION_SPEED, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
# warning-ignore:return_value_discarded
		camera_tween.interpolate_property(camera, "translation:z", ORTH_CAMERA_SIZE, PERSP_CAMERA_DISTANCE, CAMERA_INTERPOLATION_SPEED, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
# warning-ignore:return_value_discarded
		camera_tween.interpolate_property(camera, "size", ORTH_CAMERA_SIZE, PERSP_CAMERA_DISTANCE, CAMERA_INTERPOLATION_SPEED, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	else:
		camera.set_projection(Camera.PROJECTION_ORTHOGONAL)
# warning-ignore:return_value_discarded
		gimble_tween.interpolate_property(camera_gimble, "rotation_degrees:y", PERSP_CAMERA_ROTATION, ORTH_CAMERA_ROTATION, CAMERA_INTERPOLATION_SPEED, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
# warning-ignore:return_value_discarded
		camera_tween.interpolate_property(camera, "h_offset", PERSP_H_OFFSET, ORTH_H_OFFSET, CAMERA_INTERPOLATION_SPEED, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
# warning-ignore:return_value_discarded
		camera_tween.interpolate_property(camera, "v_offset", PERSP_V_OFFSET, ORTH_V_OFFSET, CAMERA_INTERPOLATION_SPEED, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
# warning-ignore:return_value_discarded
		camera_tween.interpolate_property(camera, "translation:z", PERSP_CAMERA_DISTANCE, ORTH_CAMERA_SIZE, CAMERA_INTERPOLATION_SPEED, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
# warning-ignore:return_value_discarded
		camera_tween.interpolate_property(camera, "size", PERSP_CAMERA_DISTANCE, ORTH_CAMERA_SIZE, CAMERA_INTERPOLATION_SPEED, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	
# warning-ignore:return_value_discarded
	gimble_tween.start()
# warning-ignore:return_value_discarded
	camera_tween.start()


func die():
	# TODO: Show game over screen
	# TODO: Pause game
	emit_signal("player_died")


func _on_ObstacleCollider_body_entered(body):
	if body.is_in_group("obstacle"):
		die()
