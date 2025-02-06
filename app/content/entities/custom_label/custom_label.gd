extends Entity

const Entity = preload ("../entity.gd")

@onready var button = $Button

func _ready():
	super()

	icon.value = "radio_button_checked"

	var stateInfo = await HomeApi.get_state(entity_id)

	if stateInfo == null:
		return
		
func _on_button_on_toggled(active: bool) -> void:
	
	pass # Replace with function body.
