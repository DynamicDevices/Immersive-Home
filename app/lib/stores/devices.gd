extends StoreClass
const StoreClass = preload ("./store.gd")

func _init():
	self.state = R.state({
		"devices": [{"name":"arrow", "id":"abc", "entities":[{"name":"chevron", "id":"chevron.three"},{"name":"ent", "id":"button.three"},{"name":"tooltip", "id":"tooltip.three"},{"name":"custom_label", "id":"custom_label.three"}] }]
	})

	HomeApi.on_connect.connect(func():
		var devices=await HomeApi.get_devices()

		devices.sort_custom(func(a, b):
			return a["name"].to_lower() < b["name"].to_lower()
		)

		for device in devices:
			if device["name"] == null:
				device["name"]=device["id"]

			for entity in device["entities"]:
				if entity["name"] == null:
					entity["name"]=entity["id"]

			device["entities"].sort_custom(func(a, b):
				return a["name"].to_lower() < b["name"].to_lower()
			)

		self.state.devices=devices
	)

	HomeApi.on_disconnect.connect(func():
		pass # self.state.devices=[]
	)

func clear():
	pass
