extends StoreClass
## Stores information about the house, its rooms and entities

const StoreClass = preload ("./store.gd")

func _init():
	_save_path = "user://house.json"

	self.state = R.store({
		## Type Room
		## 	 name: String
		## 	 corners: Vec2[]
		## 	 height: float
		"rooms": [],
		## Type Entity
		##   id: String
		## 	 position: Vec3
		## 	 rotation: Vec3
		## 	 scale: float
		## 	 room: String
		##   interface: String
		"entities": [],
		## Type Door
		##   id: int
		##   room1: String
		##   room2: String
		##   room1_position1: Vec3
		##   room1_position2: Vec3
		##   room2_position1: Vec3
		##   room2_position2: Vec3
		"doors": [],
		"align_position1": Vector3(),
		"align_position2": Vector3()
	})

func clearhouse(entitiesonly):
	self.state.entities = []
	if not entitiesonly:
		self.state.rooms = []
		self.state["doors"] = []
		self.state.align_position1 = Vector3()
		self.state.align_position2 = Vector3()

func get_room(name):
	for room in self.state.rooms:
		if room.name == name:
			return room
	return null
