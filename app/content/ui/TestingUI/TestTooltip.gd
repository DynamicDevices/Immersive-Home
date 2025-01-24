extends Node3D

# A new tooltip function - PCJ

@onready var getting_started_button = $GettingStartedButton
@onready var close_button = $CloseButton
@export_category("Tooltip Content")
@export var tooltipText = ["If you're seeing this, you haven't edited your tooltip text!

-Poppy", "This is page 2 and that's the jist of this page"]

func _ready():
	
	# Right now we're setting the text to a public variable,
	# it'd be good to get this editable in-app
	
	$GettingStartedLabel.text = tooltipText[1]
	
	if(tooltipText.size()<2):
		$Pagination.visible = false
	
	else:
		$Pagination.pages = tooltipText.size()

	close_button.on_button_down.connect(func():
		close()
	)

func close():
	#Store.settings.state.onboarding_complete = true
	#Store.settings.save_local()
	queue_free() # don't know what this does


func _on_pagination_on_page_changed(page: int) -> void:
	$GettingStartedLabel.text = tooltipText[page]
