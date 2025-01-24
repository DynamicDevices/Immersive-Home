extends XRCamera3D

var last_room = null

#HomeAPI removal pass
#func _physics_process(_delta):
#	if HomeApi.has_integration():
#		update_room()

func update_room():
	var room = App.house.find_room_at(global_position)

	if room != last_room:
		if room:
		#This seems like it's going to cause problems down the line
		#Can we replace HomeApi's stuff with just a master controller attached to the environment?
		
		#	HomeApi.update_room(room.name)
			last_room = room
		else:
		#	HomeApi.update_room("outside")
			last_room = null
