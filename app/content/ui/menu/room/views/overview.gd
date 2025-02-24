extends Node3D

@onready var edit_button = $EditButton
@onready var fix_button = $FixButton

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

	fix_button.on_toggled.connect(func(active):
		if active:
			App.house.fix_reference()
		else:
			App.house.disable_reference()
		#active=true
	)
