extends Entity

const Entity = preload ("../entity.gd")

@onready var button = $Button

func _ready():
	super()
	icon.value = "radio_button_checked"
	await HomeApi.watch_state(entity_id, func(new_state):
		print("custom label watch state ", new_state)
		set_stateevent(new_state)
	)

	var stateInfo = await HomeApi.get_state(entity_id)
	$entityId.text = entity_id
	# this is where we want to have backed up the text
	set_stateevent(stateInfo)

#func get_options():
#	return {
#		"longtext": $LongText.text
#	}

#func set_options(options):
#	if options.has("station_text"): 
#		$LongText.text = options["longtext"]


func set_stateevent(stateInfo):
	if stateInfo == null:
		pass
	elif not stateInfo.has("text"):
		$LongText.text = stateInfo.state
		$Title.text = stateInfo.attributes.friendly_name
	else:
		print("stateInfo ", stateInfo)
		$LongText.text = stateInfo.text
		$Title.text = stateInfo.name
		for i in len(stateInfo.next_stations):
			$NextStations.get_node("Next%d"%(i+1)).text = stateInfo.next_stations[i]
			$NextStations.get_node("Next%d"%(i+1)).visible = true
	await get_tree().process_frame  
	var laabb = $LongText.get_aabb()
	if laabb:
		$CollisionShape3D.position = laabb.get_center() + $LongText.position
		$CollisionShape3D.shape.size.x = laabb.size.x/2
		$CollisionShape3D.shape.size.y = laabb.size.y/2
	
func _on_button_on_toggled(active: bool) -> void:
	pass # Replace with function body.
