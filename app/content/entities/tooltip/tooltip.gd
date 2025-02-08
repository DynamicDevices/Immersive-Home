extends Entity

const Entity = preload ("../entity.gd")

@onready var text_edit_button = $TextEditButton
@onready var close_button = $CloseButton
@onready var input = $Input

func _ready():
	

	close_button.on_button_down.connect(func():
		close()
	)
	
	text_edit_button.on_button_down.connect(func():
		text_edit()
		)
		
func _input(event):
	if event is InputEventKey and Input.is_key_pressed(KEY_M):
		print_debug("someone pressed M")

func text_edit():
	input.visible = !input.visible

func close():
	queue_free()

	
