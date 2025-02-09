extends Entity

const Entity = preload ("../entity.gd")

@onready var text_edit_button = $TextEditButton
@onready var close_button = $CloseButton
@onready var input = $Input
@onready var tooltip_text = $TooltipText

var keyboard_input = false


func _ready():
	
	close_button.on_button_down.connect(func():
		close()
	)
	
	# Our new text edit button
	text_edit_button.on_button_down.connect(func():
		text_edit()
		)
		
# For testing without VR
func _input(event):
	if event is InputEventKey and Input.is_key_pressed(KEY_H):
		text_edit()
		

# Bring up/Hide our input that we use to change the body text
func text_edit():
	input.visible = !input.visible

# It may be worth closing this 
func close():
	queue_free()

# Change our body text with the input element we just brought up
func _on_input_on_text_changed(text: String) -> void:
	tooltip_text.text = text
