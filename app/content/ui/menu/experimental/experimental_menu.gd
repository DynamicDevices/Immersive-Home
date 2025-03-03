extends Node3D

@onready var button_1 = $JulianButton1
@onready var button_2 = $JulianButton2


func _ready():
	
	button_1.on_button_down.connect(func():
		button_1_pressed()
	)
	
	button_2.on_button_down.connect(func():
		button_2_pressed()
	)
	
func button_1_pressed():
	pass

func button_2_pressed():
	pass
