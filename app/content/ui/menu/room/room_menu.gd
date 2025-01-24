extends Node3D

const window_scene = preload ("./window.tscn")

@onready var background = $Background

func _ready():
	background.visible = false

# I've disabled this whole bit as part of the initial HA Disconnection pass
# this menu may not work now, I haven't been able to test it - PCJ

#	HomeApi.on_connect.connect(func():
		# var rooms = App.house.get_rooms(0)

		# for room in rooms:
		# 	var mesh = room.wall_mesh
		#pass
#	)
