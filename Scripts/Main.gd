extends Spatial

#export (PackedScene) var player_scene = preload("res://Scenes/MainScenes/Player.tscn")
export (PackedScene) var player_scene = preload("res://Scenes/MainScenes/PlayerRigid.tscn")

onready var player
onready var game_over_menu = get_node("GameOver")

func _ready():
	player = player_scene.instance()
	
	add_child(player)
	player.connect("player_died", self, "player_died")
	
	game_over_menu.get_node("CenterContainer/VBoxContainer/HBoxContainer/Restart").connect("pressed", self, "restart")


func restart():
# warning-ignore:return_value_discarded
	player.queue_free()
	get_tree().reload_current_scene()
	get_tree().paused = false

func player_died():
	game_over_menu.visible = true
	get_tree().paused = true
