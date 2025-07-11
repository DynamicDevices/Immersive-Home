extends Entity

const Entity = preload ("../entity.gd")

@onready var animation: AnimatedSprite3D = $AnimatedSprite3D
@onready var weather_label: Label3D = $WeatherLabel
@onready var temp_label: Label3D = $TempLabel
@onready var humid_label: Label3D = $HumidLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	var stateInfo = await HomeApi.get_state(entity_id)

	set_state(stateInfo)

	await HomeApi.watch_state(entity_id, func(new_state):
		set_state(new_state)
	)
	var mat : StandardMaterial3D = $sari/Armature/Skeleton3D/Plane.get_surface_override_material(0)
	print("iiiii ", get_index())
	print(mat.albedo_texture)
	mat.albedo_texture = load("res://content/sarimaterials/sari%d.jpg" % ((get_index() % 3) + 1))


var filteredcamerapos = Vector3(0,0,0)
var filteredlefthandpos = Vector3(0,0,0)
var filteredrighthandpos = Vector3(0,0,0)
const motionfilter = 0.1

func filtapply(x, fpos, springbone):
	var pos = x.global_position
	fpos = pos*motionfilter + fpos*(1.0-motionfilter)
	var filterdev = (fpos - pos).length()
	springbone.global_position = pos
	springbone.radius = min(0.4, filterdev*4)
	return fpos

func _process(delta):
	#var x = get_node_or_null("%XRCamera3D")
	var xc = get_node("/root/Main").camera
	var xl = get_node("/root/Main").controller_left
	var xr = get_node("/root/Main").controller_right
	if xl:
		filteredlefthandpos = filtapply(xl, filteredlefthandpos, $sari/Armature/Skeleton3D/SpringBoneSimulator3D/LSpringBoneCollisionSphere3D)
	if xr:
		filteredrighthandpos = filtapply(xr, filteredrighthandpos, $sari/Armature/Skeleton3D/SpringBoneSimulator3D/RSpringBoneCollisionSphere3D)

func set_state(stateInfo):
	if stateInfo == null:
		return

	var state = stateInfo["state"]
	var attributes = stateInfo["attributes"]

	if attributes.has("temperature")&&attributes.has("temperature_unit"):
		temp_label.text = str(attributes["temperature"]) + " " + attributes["temperature_unit"]

	if attributes.has("humidity"):
		humid_label.text = str(attributes["humidity"]) + "%"

	match state:
		"clear-night":
			weather_label.text = "Clear Night"
			animation.play("clear-night")
		"cloudy":
			weather_label.text = "Cloudy"
			animation.play("partly-cloudy-day")
		"fog":
			weather_label.text = "Fog"
			animation.play("fog")
		"hail":
			weather_label.text = "Hail"
			animation.play("hail")
		"lightning":
			weather_label.text = "Lightning"
			animation.play("thunderstorms")
		"lightning-rainy":
			weather_label.text = "Lightning Rainy"
			animation.play("thunderstorms-rain")
		"partlycloudy":
			weather_label.text = "Partly Cloudy"
			animation.play("partly-cloudy-day")
		"pouring":
			weather_label.text = "Pouring"
			animation.play("rain")
		"rainy":
			weather_label.text = "Rainy"
			animation.play("drizzle")
		"snowy":
			weather_label.text = "Snowy"
			animation.play("snow")
		"snowy-rainy":
			weather_label.text = "Snowy Rainy"
			animation.play("sleet")
		"sunny":
			weather_label.text = "Sunny"
			animation.play("clear-day")
		"windy":
			weather_label.text = "Windy"
			animation.play("wind")
		"windy-variant":
			weather_label.text = "Windy Variant"
			animation.play("wind")
		"exceptional":
			weather_label.text = "Exceptional"
			animation.play("code-red")
