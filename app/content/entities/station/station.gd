extends Entity

const Entity = preload ("../entity.gd")

@onready var station_node = preload("res://content/entities/station/station.tscn")
@onready var text_edit_button = $TextEditButton
@onready var close_button = $NextButtonContainer/NextButton
@onready var input = $Input
@onready var station_text = $StationText
@onready var station_icon = $StationIcon

var station_name = "Blank name"
var next_station = null
var previous_station = null
var station_text_R = R.state("Blank Station")
var next_stations = ""
var mqtt = null
var dev_state = false
var station_id = "unknown"

var event = EventPointer

func _ready():
	super()
	station_icon.visible = false
	
	close_button.on_button_down.connect(close)
	
	# Our new text edit button
	text_edit_button.on_button_down.connect(text_edit)
	
	get_node("/root/Main/").dev_state_changed.connect(_dev_state_changed)
	R.effect(func(_arg):
		if station_text_R.value != null: 
			station_text.text = station_text_R.value
	)
	
	get_node("/root/Main/").reset.connect(_reset)
		
	if var_to_str(station_text.text).contains(" "):
		station_name = var_to_str(station_text.text).split(" ", 1)[0]
	else:
		station_name = var_to_str(station_text.text)
	
	
	# These following things need to wait for everything to get loaded,
	# so i've added a manual delay for now. - PCJ
	await get_tree().create_timer(0.1).timeout

	for x in Store.house.state.entities:
		#print("stateentities ", var_to_str(global_position) + var_to_str(x.position))
		if global_position.is_equal_approx(x.position):
			#print(x._node_iid)
			x._node_iid = get_instance_id()
			#print(x._node_iid)

	await HomeApi.watch_state(entity_id, set_options)
	
	if next_station != null:
		station_icon.visible = true
	else:
		station_icon.visible = false
	if previous_station != null and previous_station.station_icon.visible:
		station_icon.visible = false
	mqtt = get_node("/root/Main/MQTT")
	text_edit_button.visible = Store.settings.state.dev_state

# When we bring up/hide our input that we use to change the body text
func text_edit():
	input.visible = !input.visible
	_state_update()

func _on_activate_button_on_button_down():
	activate(null)

func activate(frompt):
	visible = true
	var regex = RegEx.new()
	regex.compile("(?<vidplace>Video[^:]*): (?<vidname>\\S+)")
	var result = regex.search(station_text.text)
	if result:
		var vidplace = get_node_or_null(result.get_string("vidplace"))
		if not vidplace:
			print("Vid place ", result.get_string("vidplace"), " not found")
			vidplace = get_node(result.get_string("VideoPlaceTop"))
		var vidname = result.get_string("vidname")
		get_node("/root/Main/MediaBrowserObjects").playvideo(vidname, vidplace.global_transform, true)
	if frompt != null:
		var tween : Tween = get_node("/root/Main/MagicTinsel").gotinselpttopt(frompt, $KeyboardPlace.global_position)
		await tween.finished
		
	var ns = next_stations.split(" ")
	next_station = null
	if ns and ns[0]:
		next_station = get_node("/root/Main/House").find_station_byid(ns[0])
	
func close():
	visible = false
	$CollisionShape3D.disabled = true
	if next_station != null:
		get_node("/root/Main/MediaBrowserObjects").stopvideo()
		next_station.activate($KeyboardPlace.global_position)
		App.controller_right.get_node("hand_r/Compass Base").set_target(next_station)
	else:
		App.controller_right.get_node("hand_r/Compass Base").set_target(null)

func _reset():
	visible = true
	$CollisionShape3D.disabled = false
	_state_update()

func _state_update() -> void:
	if next_station != null:
		station_icon.visible = true
		App.controller_right.get_node("hand_r/Compass Base").get_script().set_target(self)
	else:
		station_icon.visible = false
	if previous_station != null and previous_station.station_icon.visible:
		station_icon.visible = false

# Change our body text with the input element we just brought up
func _on_input_on_text_changed(text: String) -> void:
	station_text.text = text
	#_text_R.set_state(entity_id, "_text", {"_text": text})
	station_text_R.value = text

func get_options():
	return {
		"station_text": station_text_R.value,
		"station_name": station_name,
		"next_stations": next_stations,
		"station_id": station_id
	}

func set_options(options):
	if options.has("station_text"): 
		station_text_R.value = options["station_text"]
	if options.has("station_name"):
		station_name = options["station_name"]
	if options.has("next_stations"):
		next_stations = options["next_stations"]
	if options.has("station_id"):
		station_id = options["station_id"]

func _dev_state_changed(value):
	text_edit_button.visible = value

	$NextButtonContainer/NextPreviewTrail.visible = false
	if value:
		$MeshInstance3D.material_overlay = load("res://content/Materials/NoDepthTest.tres")
	else:
		$MeshInstance3D.material_overlay = null

	if value:
		var ns = next_stations.split(" ")
		if ns and ns[0]:
			var lnext_station = get_node("/root/Main/House").find_station_byid(ns[0])
			if lnext_station:
				var frompt = $NextButtonContainer/NextButton.global_position
				var topt = lnext_station.global_position
				$NextButtonContainer/NextPreviewTrail.look_at_from_position((frompt + topt)*0.5, topt)
				$NextButtonContainer/NextPreviewTrail.scale.z = (frompt - topt).length()
				$NextButtonContainer/NextPreviewTrail.visible = true
