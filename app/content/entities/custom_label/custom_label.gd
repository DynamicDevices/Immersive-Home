extends Entity

const Entity = preload ("../entity.gd")

@onready var button = $Button
@onready var long_text = $LongText
@onready var title = $Title
var next_stations = ""

func _ready():
	super()
	icon.value = "radio_button_checked"
	await HomeApi.watch_state(entity_id, func(new_state):
		set_stateevent(new_state)
	)

	var stateInfo = await HomeApi.get_state(entity_id)
	$entityId.text = entity_id
	# this is where we want to have backed up the text
	set_stateevent(stateInfo)

	$NextStations/Next1.on_button_down.connect(func():
		nextstation(1)
	)
	$NextStations/Next2.on_button_down.connect(func():
		nextstation(2)
	)

func nextstation(n):
	var nextstation = null
	var nextstationid = "text."+next_stations.split(" ")[n-1]
	for room in get_node("/root/Main/House/Rooms").get_children():
		for entity in room.get_node("Entities").get_children():
			if nextstationid == entity.entity_id:
				nextstation = entity
	var p0 = get_node("KeyboardPlace").global_position
	var p1 = p0 + Vector3(0,4,0)
	if nextstation:
		p1 = nextstation.get_node("KeyboardPlace").global_position
	get_node("/root/Main/MagicTinsel").gotinselpttopt(p0, p1)

				
func get_options():
	return {
		"longtext": long_text.text,
		"title":title.text,
		"next_stations":next_stations
	}

func set_options(options):
	if options.has("longtext"): 
		long_text.text = options["longtext"]
	if options.has("title"):
		title.text = options["title"]
	if options.has("next_stations"):
		next_stations = options["next_stations"]
	update_labelshape()
	
func set_stateevent(stateInfo):
	if stateInfo == null:
		pass
	elif not stateInfo.has("text"):
		long_text.text = stateInfo.state
		title.text = stateInfo.attributes.friendly_name
	else:
		print("stateInfo ", stateInfo)
		long_text.text = stateInfo.text
		title.text = stateInfo.name
		next_stations = stateInfo.next_stations
	update_labelshape()

func update_labelshape():
	var snext_stations = next_stations.split(" ")
	while snext_stations and not snext_stations[0]:
		snext_stations.remove_at(0)
	for i in range(min(len(snext_stations), 2)):
		$NextStations.get_node("Next%d/Label3D"%(i+1)).text = snext_stations[i]
		$NextStations.get_node("Next%d"%(i+1)).visible = true
		$NextStations.get_node("Next%d"%(i+1)).disabled = false
	for i in range(len(snext_stations), 2):
		$NextStations.get_node("Next%d"%(i+1)).visible = false
		$NextStations.get_node("Next%d"%(i+1)).disabled = true

	await get_tree().process_frame  
	var laabb = $LongText.get_aabb()
	if laabb:
		$CollisionShape3D.position = laabb.get_center() + $LongText.position
		$CollisionShape3D.shape.size.x = laabb.size.x/2
		$CollisionShape3D.shape.size.y = laabb.size.y/2

func _on_button_on_toggled(active: bool) -> void:
	pass # Replace with function body.
