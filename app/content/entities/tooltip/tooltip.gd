extends Entity

const Entity = preload ("../entity.gd")

@onready var text_edit_button = $TextEditButton
@onready var close_button = $CloseButton
@onready var input = $Input
@onready var tooltip_text = $TooltipText

var tooltip_name = "Blank Tooltip"
var next_tooltip = null
var previous_tooltip = null
var tooltip_text_R = R.state("Blank Tooltip")
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
		if tooltip_text_R.value != null: tooltip_text.text = tooltip_text_R.value
		)
		
	
		
	if var_to_str(tooltip_text.text).contains(" "):
		tooltip_name = var_to_str(tooltip_text.text).split(" ",1)[0]
	else:
		tooltip_name = var_to_str(tooltip_text.text)
	
	if next_tooltip != null:
		close_button.label = "forward"
	if previous_tooltip != null and previous_tooltip.visible:
		self.visible = false
	mqtt = get_node("/root/Main/MQTT")
	

# When we bring up/hide our input that we use to change the body text
func text_edit():
	input.visible = !input.visible
	
	#tooltip_text_R.value = tooltip_text.text
	
	# Check tooltip text for identifier
	if tooltip_text.text.contains(" "):
		self.name = tooltip_text.text.split(" ",1)[0] # Set name to word before " "
		mqtt.publish("stfc/tooltip_name_~", var_to_str(self.name))
		
	else:
		self.name = tooltip_text.text
		mqtt.publish("stfc/tooltip_name", var_to_str(self.name))
		if close_button.label == "forward": close_button.label = "done"

# It may be worth closing this 
func close():
	# queue_free() # Our old method of closing bits
	visible = false
	$CollisionShape3D.disabled = true
	if(next_tooltip != null):
		next_tooltip.visible = true

func tooltip_state_update(prev_tooltip: Node3D) -> void:
	previous_tooltip = prev_tooltip
	if next_tooltip != null:
		close_button.label = "forward"
	if previous_tooltip != null and previous_tooltip.visible:
		self.visible = false

# Change our body text with the input element we just brought up
func _on_input_on_text_changed(text: String) -> void:
	tooltip_text.text = text
	#tooltip_text_R.set_state(entity_id, "tooltip_text", {"tooltip_text": text})
	tooltip_text_R.value = text
	
func get_options():
	return {
		"tooltip_text": tooltip_text_R.value,
	}

func set_options(options):
	if options.has("tooltip_text"): tooltip_text_R.value = options["tooltip_text"]
