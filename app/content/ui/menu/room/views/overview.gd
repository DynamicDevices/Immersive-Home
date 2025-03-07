extends Node3D

@onready var edit_button = $EditButton
@onready var walls_button = $WallsButton

#var active = false:
#	set(value):
#		if value:
#			edit_button.label = "save"
#			fix_button.disabled = true
#			fix_button.visible = false
#		else:
#			edit_button.label = "edit"
#			fix_button.disabled = false
#			fix_button.visible = true
#		active = value

func _ready():

	# Show or hide walls
	walls_button.on_toggled.connect(func(active): 
		
		App.house.show_walls(active)
		)

	# Activate or deactivate Nitwel's reference fixer
	edit_button.on_toggled.connect(func(active):
		if active:
			App.house.fix_reference()
			edit_button.label = "save"
		else:
			App.house.save_reference()
			App.house.disable_reference()
			edit_button.label = "edit"
		#active=true
	)
