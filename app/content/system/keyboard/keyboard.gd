@tool
extends StaticBody3D

const button_scene = preload ("res://content/ui/components/button/button.tscn")

@onready var keys = $Keys
@onready var caps_button = $Caps
@onready var backspace_button = $Backspace
@onready var paste_button = $Paste
@onready var return_button = $Return
@onready var space_button = $Space
var key_list = [
	[KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_0, KEY_ASCIITILDE],
	[KEY_Q, KEY_W, KEY_E, KEY_R, KEY_T, KEY_Y, KEY_U, KEY_I, KEY_O, KEY_P, KEY_SLASH],
	[KEY_A, KEY_S, KEY_D, KEY_F, KEY_G, KEY_H, KEY_J, KEY_K, KEY_L, KEY_COLON, KEY_BACKSLASH],
	[KEY_Z, KEY_X, KEY_C, KEY_V, KEY_B, KEY_N, KEY_M, KEY_COMMA, KEY_PERIOD, KEY_MINUS]
]

var caps = false:
	set(value):
		caps = value
		update_labels()

func _ready():
	_create_keys()

	if Engine.is_editor_hint():
		return
	get_parent().remove_child.call_deferred(self)
	
	_prepare_keyboard_spawn()
	_connect_key_events()

func _prepare_keyboard_spawn():
	if Engine.is_editor_hint():
		return

	EventSystem.on_focus_in.connect(func(event):
		if is_inside_tree():
			return

		App.main.add_child(self)
		var aat = event.target.find_parent("AnimationContainer")
		var pat = aat if aat != null else event.target.get_parent()
		var kp = pat.get_node_or_null("KeyboardPlace")
		if kp:
			global_transform = kp.global_transform
	)

	EventSystem.on_focus_out.connect(func(event):
		if !is_inside_tree():
			return

		App.main.remove_child(self)
	)

func _create_keys():
	for row in key_list:
		for key in row:
			var key_node = _create_key(key)
			keys.add_child(key_node)

			if Engine.is_editor_hint():
				continue

			key_node.on_button_down.connect(func():
				_emit_event("key_down", key)
			)
			key_node.on_button_up.connect(func():
				_emit_event("key_up", key)
			)

	keys.columns = key_list[0].size()

func _connect_key_events():
	if Engine.is_editor_hint():
		return

	backspace_button.on_button_down.connect(func():
		_emit_event("key_down", KEY_BACKSPACE)
	)

	backspace_button.on_button_up.connect(func():
		_emit_event("key_up", KEY_BACKSPACE)
	)

	caps_button.on_button_down.connect(func():
		caps=true
		_emit_event("key_down", KEY_CAPSLOCK)
	)

	caps_button.on_button_up.connect(func():
		caps=false
		_emit_event("key_up", KEY_CAPSLOCK)
	)

	paste_button.on_button_down.connect(func():
		# There is no KEY_PASTE obviously, so we use KEY_INSERT for now
		_emit_event("key_down", KEY_INSERT)
	)

	paste_button.on_button_up.connect(func():
		_emit_event("key_up", KEY_INSERT)
	)
	
	# Enter & Space added for station editing
	
	return_button.on_button_down.connect(func():
		_emit_event("key_down", KEY_ENTER)
		)
		
	return_button.on_button_up.connect(func():
		_emit_event("key_up", KEY_ENTER)
		)
		
	space_button.on_button_down.connect(func():
		_emit_event("key_down", KEY_SPACE)
	)
	
	space_button.on_button_up.connect(func():
		_emit_event("key_up", KEY_SPACE)
	)

func _create_key(key: Key):
	var key_node = button_scene.instantiate()
	
	key_node.label = EventKey.key_to_string(key, caps)
	key_node.size = Vector3(0.05, 0.05, 0.01)
	key_node.focusable = false
	key_node.font_size = 32
	key_node.echo = true
	key_node.set_meta("key", key)

	return key_node

func update_labels():
	for key_button in keys.get_children():
		if caps:
			key_button.label = key_button.label.to_upper()
		else:
			key_button.label = key_button.label.to_lower()

func _emit_event(type: String, key: Key):
	var event = EventKey.new()
	event.key = key
	event.shift_pressed = caps
	
	EventSystem.emit(type, event)
