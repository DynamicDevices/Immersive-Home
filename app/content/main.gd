extends Node3D

const VoiceAssistant = preload ("res://content/system/assist/assist.tscn")
const environment_passthrough_material = preload ("res://assets/environment_passthrough.tres")
const Menu = preload ("res://content/ui/menu/menu.gd")
const OnboardingScene = preload ("res://content/ui/onboarding/onboarding.tscn")
const MetaSceneEntity = preload ("res://content/system/house/meta_scene_entity/meta_scene_entity.tscn")

@onready var environment: WorldEnvironment = $WorldEnvironment
@onready var camera: XRCamera3D = %XRCamera3D
@onready var controller_left = %XRControllerLeft
@onready var controller_right = %XRControllerRight
@onready var house = $House
@onready var menu: Menu = $Menu
@onready var xr: XRToolsStartXR = $StartXR
@onready var xr_origin: XROrigin3D = $XROrigin3D

var voice_assistant = null
var meta_scene_manager = null
var xr_interface : XRInterface

func _ready():
	if OS.get_name() == "Android":
		# OS.request_permissions()
		environment.environment = environment_passthrough_material
		get_viewport().transparent_bg = true
	else:
		RenderingServer.set_debug_generate_wireframes(true)

	create_voice_assistant()

	xr.xr_started.connect(func():
		if HomeApi.has_connected() == false:
			HomeApi.start()
	)

	if OS.get_model_name() == "Quest":
		print("Scene manage ", ClassDB.can_instantiate("OpenXRFbSceneManager"))
		meta_scene_manager = ClassDB.instantiate("OpenXRFbSceneManager")
		meta_scene_manager.auto_create = false
		meta_scene_manager.visible = false
		meta_scene_manager.default_scene = MetaSceneEntity
		
		

		meta_scene_manager.openxr_fb_scene_data_missing.connect(func():
			meta_scene_manager.request_scene_capture()
		)
		xr_interface = XRServer.find_interface('OpenXR')
		
	if xr_interface != null:
			# Connect to boundary update event
		xr_interface.play_area_changed.connect(_boundary_snapped)
			
		

	xr_origin.add_child(meta_scene_manager)

	HomeApi.on_connect.connect(func():
		start_setup_flow.call_deferred()
	)
	$MQTT.connect_to_broker("mosquitto.doesliverpool.xyz")

func start_setup_flow():
	var onboarding = OnboardingScene.instantiate()
	add_child(onboarding)

	await onboarding.tree_exited

	if Store.house.state.rooms.size() == 0:
		house.create_room("Room 1")

func create_voice_assistant():
	if Store.settings.is_loaded() == false:
		await Store.settings.on_loaded

	var settings_store = Store.settings.state

	R.effect(func(_arg):
		if settings_store.voice_assistant == true&&voice_assistant == null:
			voice_assistant=VoiceAssistant.instantiate()
			add_child(voice_assistant)
		elif settings_store.voice_assistant == false&&voice_assistant != null:
			remove_child(voice_assistant)
			voice_assistant.queue_free()
	)

func _process(delta):
	_move_camera_pc(delta)

func _input(event):

	# Debugging Features
	if event is InputEventKey and Input.is_key_pressed(KEY_F10):
		var vp = get_viewport()
		vp.debug_draw = (vp.debug_draw + 1) % 5
		
	if event is InputEventKey and Input.is_key_pressed(KEY_M):
		menu.toggle_open()
	
	if event is InputEventKey and Input.is_key_pressed(KEY_Y):
		print(ProjectSettings.globalize_path(Store.house._save_path))
	
	if event is InputEventKey and Input.is_key_pressed(KEY_U):
		var content = JSON.parse_string(FileAccess.get_file_as_string(Store.house._save_path))
		if content:
			print (content)
		
	
func _move_camera_pc(delta):
	if OS.get_name() == "Android": return
		
	var camera_basis = camera.get_global_transform().basis

	camera_basis.x.y = 0
	camera_basis.z.y = 0
	camera_basis.y = Vector3(0, 1, 0)
	camera_basis.x = camera_basis.x.normalized()
	camera_basis.z = camera_basis.z.normalized()

	var movement = camera_basis * _vector_key_mapping(KEY_D, KEY_A, KEY_S, KEY_W) * delta

	camera.position += movement
	controller_left.position += movement
	controller_right.position += movement

func _vector_key_mapping(key_positive_x: int, key_negative_x: int, key_positive_y: int, key_negative_y: int):
	var x = 0
	var y = 0
	if Input.is_physical_key_pressed(key_positive_y):
		y = 1
	elif Input.is_physical_key_pressed(key_negative_y):
		y = -1
	
	if Input.is_physical_key_pressed(key_positive_x):
		x = 1
	elif Input.is_physical_key_pressed(key_negative_x):
		x = -1
	
	var vec = Vector3(x, 0, y)
	
	if vec:
		vec = vec.normalized()
	
	return vec

# Our MQTT debug stuff

func _boundary_snapped() -> void:
	$MQTT.publish("stfc/boundary_snap", ".* BOUNDARY SNAPPED *.")
	$MQTT.publish("stfc/boundary snap", var_to_str(xr_interface.get_play_area()))
	
func _on_mqtt_broker_connected() -> void:
	$MQTT.subscribe("stfc/#")
	$MQTT.publish("stfc/status", "we are good")
	var scontent = FileAccess.get_file_as_string(Store.house._save_path)
	var content = JSON.parse_string(scontent)
	if content:
		$MQTT.publish("stfc/room", var_to_str(content))
	$MQTT.publish("stfc/pos", var_to_str(%XRCamera3D.position))
	

func _on_mqtt_received_message(topic: Variant, message: Variant) -> void:
	prints(" got message: ", topic, message)

# mosquitto_sub -h mosquitto.doesliverpool.xyz -v -t "stfc/#"
# mosquitto_pub -h mosquitto.doesliverpool.xyz -t "stfc/alex/L" -m "is talking"


#func _on_xr_controller_left_button_pressed(name: String) -> void:
#	var camera_position = %XRCamera3D.position
#	$MQTT.publish("stfc/pos", var_to_str(camera_position))
#	$MQTT.publish("stfc/pos_dif", var_to_str(abs(camera_position-debug_reference_position)))
#	debug_reference_position = camera_position
