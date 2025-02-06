extends Entity

const Entity = preload ("../entity.gd")

@onready var getting_started_button = $GettingStartedButton
@onready var close_button = $CloseButton
@onready var textbox = $Viewport2Din3D/Viewport/ScrollingTextbox

func _ready():
	

	close_button.on_button_down.connect(func():
		close()
	)

func close():
	queue_free()


func _on_getting_started_button_on_button_down() -> void:
	textbox.add_text(JSON.parse_string(FileAccess.get_file_as_string(Store.house._save_path)))
	pass # Replace with function body.
