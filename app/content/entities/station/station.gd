extends Entity

const Entity = preload ("../entity.gd")

@onready var station_node = preload("res://content/entities/station/station.tscn")
@onready var text_edit_button = $TextEditButton
@onready var close_button = $CloseButton
@onready var input = $Input
@onready var station_text = $StationText

var station_name = "Blank Station"
var next_station = null
var previous_station = null
var station_text_R = R.state("Blank Station")
var mqtt = null


func _ready():
	
	close_button.on_button_down.connect(func():
		close()
	)
	
	# Our new text edit button
	text_edit_button.on_button_down.connect(func():
		text_edit()
	)
		
	R.effect(func(_arg):
		if station_text_R.value != null: station_text.text = station_text_R.value
		)
		
	if var_to_str(station_text.text).contains(" "):
		station_name = var_to_str(station_text.text).split(" ",1)[0]
	else:
		station_name = var_to_str(station_text.text)
	
	if next_station != null:
		close_button.label = "forward"
	if previous_station != null and previous_station.visible:
		self.visible = false
	mqtt = get_node("/root/Main/MQTT")
	

# When we bring up/hide our input that we use to change the body text
func text_edit():
	input.visible = !input.visible
	
	# Check station text for identifier
	if station_text.text.contains(" "):
		station_name = station_text.text.split(" ",1)[0] # Set name to word before " "
		mqtt.publish("stfc/station_name_~", var_to_str(station_name))
		for device in Store.house.state.entities:
			if device["id"] == "station.three":
				var device_node = instance_from_id(device["_node_iid"])
				device_node.station_update(self, station_text.text.split(" ",1)[1])
			
		_state_update()
		
	else:
		station_name = station_text.text
		mqtt.publish("stfc/station_name", var_to_str(station_name))
		if close_button.label == "forward": close_button.label = "done"
		_state_update()

# It may be worth closing this 
func close():
	# queue_free() # Our old method of closing bits
	visible = false
	$CollisionShape3D.disabled = true
	if(next_station != null):
		next_station.visible = true

func _state_update() -> void:
	if next_station != null:
		close_button.label = "forward"
	if previous_station != null and previous_station.visible:
		self.visible = false

# Change our body text with the input element we just brought up
func _on_input_on_text_changed(text: String) -> void:
	station_text.text = text
	#_text_R.set_state(entity_id, "_text", {"_text": text})
	station_text_R.value = text
	
	
func _on_next__button_on_toggled(active: bool) -> void:
	$NextStationInput.visibile = active
	
func get_options():
	return {
		"station_text": station_text_R.value,
	}

func set_options(options):
	if options.has("station_text"): station_text_R.value = options["station_text"]


func _on_next_station_input_on_text_changed(text: String) -> void:
	if get_node("/root/Main/" + text) != get_node("/root/Main/") and get_node("/root/Main/" + text) != null:
		next_station = get_node("/root/Main/" + text)
		next_station._state_update(self)


func station_update(origin: Variant, name_search: Variant) -> void:
	print("we got here!!!")
	if (name_search == station_name):
		print("next station set!")
		origin.next_station = self
		origin._state_update()
		previous_station = origin
