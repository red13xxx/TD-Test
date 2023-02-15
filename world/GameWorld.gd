extends Node2D
class_name GameWorld

const turret = preload("res://turret/Turret.tscn")
const shed = preload("res://turret/Shed.tscn")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _unhandled_input(event):
	if event.is_action_pressed("key_exit"):
		get_tree().quit()

func _on_Turret_Button_pressed():
	$Grid.add_object(turret.instance(), true)


func _on_Shed_Button_pressed():
	$Grid.add_object(shed.instance(), true)
