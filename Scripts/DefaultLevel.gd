extends Spatial
class_name DefaulLevel

const SPEED := 10.0
var countdown = 3

func _ready():
	while countdown > 0:
		yield(get_tree().create_timer(1.0), "timeout")
		countdown -=1


func _process(delta):
	if countdown:
		print(countdown)
	else:
		translation.x -= SPEED * delta

