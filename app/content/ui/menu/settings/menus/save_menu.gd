extends Node3D

@onready var save = $Save
@onready var clear_save = $ClearSave

func _ready():

	save.on_button_down.connect(func():
		App.house.save_all_entities()
	)

	clear_save.on_button_down.connect(func():
		Store.house.clear()
		App.house.update_house()
	)
