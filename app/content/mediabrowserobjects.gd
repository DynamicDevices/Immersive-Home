extends Node3D

# see https://developers.home-assistant.io/docs/api/websocket/
# trying to get the media browser data from here, so we can download images
# direct from the HASS as an input for managing images
# https://mr5g.dynamicdevices.co.uk/media-browser/browser/app%2Cmedia-source%3A%2F%2Fimage_upload

const mediacachedir = "user://mediacachedir/"
var mediacachelist = [ ]
@onready var androidcompositionlayer = get_node("../XROrigin3D/OpenXRCompositionLayerQuad")
var exoplayer = null


func _ready():
	firstpos = get_child(0).transform
	HomeApi.on_connect.connect(fetch_mediafiles)
	if not DirAccess.dir_exists_absolute(mediacachedir):
		DirAccess.make_dir_absolute(mediacachedir)
	var fout = FileAccess.open("user://test.txt", FileAccess.WRITE)
	print("  **** ", fout.get_path_absolute())
	print(listdir("user://"))
	fout.close()
	mediacachelist = listdir(mediacachedir)
	print("mediacachelist ", mediacachelist)
	if OS.get_name() == "Android" and Engine.has_singleton("godot_exoplayer"):
		exoplayer = Engine.get_singleton("godot_exoplayer")
		#exoplayer.on_player_ready(on_player_ready)
		#exoplayer.on_video_end(on_video_end)
		#exoplayer.on_player_error(on_player_ready)
	
func on_player_ready(id, duration):
	prints("on_player_ready ", id, duration)
func on_video_end(id):
	prints("on_video_end ", id)
func on_player_error(id, msg):
	prints("on_player_ready ", id, msg)

var Dvidplaying = ""
func playnextvideo():
	var video_uri : String = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
	#var video_uri : String = "https://mr5g.dynamicdevices.co.uk/media/local/hgtakeoffscale.mp4?authSig=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI5ZWRlNjdjNTc5Njg0ZGJkYTVjNTRiNzA2NGM0MDFlYiIsInBhdGgiOiIvbWVkaWEvbG9jYWwvaGd0YWtlb2Zmc2NhbGUubXA0IiwicGFyYW1zIjpbXSwiaWF0IjoxNzQxMDI5NzU0LCJleHAiOjE3NDExMTYxNTR9.Lr2_lKlIVdfuanrHMVtKeMhf5taXLdS4t6pd0ZUF0UI"
	for c in mediacachelist:
		if c.ends_with(".mp4"):
			if c != Dvidplaying:
				Dvidplaying = c
				break
	if Dvidplaying:
		var fin = FileAccess.open(mediacachedir+Dvidplaying, FileAccess.READ)
		video_uri = fin.get_path_absolute()
		print("video_uri ", video_uri)
		fin.close()
		

	if exoplayer:
		var androidsurface = androidcompositionlayer.get_android_surface()
		if androidsurface:
			exoplayer.createExoPlayerSurface(1, video_uri, androidsurface)
			exoplayer.play(1)
			## pause ( id of player)
			## exoplayer.pause(1)
			await get_tree().create_timer(2).timeout
			#print("XXXX ", exoplayer.getResolutions(1))
			#print("XXXX ", exoplayer.getDuration(1))


func listdir(d):
	var res = [ ]
	var dir = DirAccess.open(d)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		res.push_back(file_name)
		file_name = dir.get_next()
	return res
	
func fetch_mediafiles():
	if not HomeApi.has_connected():
		return
	var serverbase = Store.settings.state.url.replace("wss://", "https://").replace(":8123", "")
	# serverbase = "https://mr5g.dynamicdevices.co.uk"
	print("serverbase ", serverbase) # "https://mr5g.dynamicdevices.co.uk"
	var jmediacontent = { "type": "media_source/browse_media", "media_content_id":"media-source://media_source" }
	var response = await HomeApi.api.connection.send_request_packet(jmediacontent)
	if not (response.payload.get("success") and response.payload.type == "result"):
		print("fetch_mediaimages failed")
		return
	var mediabrowserobjects = response.payload.result.children
	for c in mediabrowserobjects:
		if not (c.media_class == "image" or c.media_class == "video"):
			continue
		if mediacachelist.has(c.title):
			continue
		var jmediaresolve = { "type":"media_source/resolve_media","media_content_id":c.media_content_id }
		var response2 = await HomeApi.api.connection.send_request_packet(jmediaresolve)
		if not (response2.payload.get("success") and response2.payload.get("type") == "result"):
			continue
		var url = response2.payload.result.url
		var mimetype = response2.payload.result.mime_type
		var uurl = serverbase+url
		var http_request = HTTPRequest.new()
		add_child(http_request)
		var df = mediacachedir+c.title
		http_request.download_file = df
		var error = http_request.request(uurl)
		print("uurl ", uurl)
		print("asdad ", [df, http_request.download_file])
		if error != OK:
			print("An error occurred in the HTTP request.")
			continue
		var params: Array = await http_request.request_completed  # result, response_code, headers, body
		print(" responsecode ", params[1])
		print(" headers ", params[2])
		print(" filelength ", len(params[3]))
		http_request.queue_free()
		mediacachelist = listdir(mediacachedir)


		#var fout = FileAccess.open(mediacachedir+c.title, FileAccess.WRITE)
		#params. 
				
#	var img = Image.new()
#	img.load_jpg_from_buffer(params[3])


			
#	for imageurl in imageurls:
#		await fetchurldata(imageurl)



var firstpos = null
var ngg = 1

func fetchurldata(uurl):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	#http_request.request_completed.connect(self._http_request_completed)
	var error = http_request.request(uurl)
	if error != OK:
		print("An error occurred in the HTTP request.")
		return
	var params: Array = await http_request.request_completed  #result, response_code, headers, body
	print("headers ", params[2])
	var img = Image.new()
	img.load_jpg_from_buffer(params[3])
	img.generate_mipmaps()
	var xrat = img.get_width()*1.0/img.get_height()
	var gg = load("res://content/mediabrowserbox.tscn").instantiate()
	gg.get_node("MeshInstance3D").mesh.size.x = xrat
	gg.get_node("CollisionShape3D").shape.size.x = xrat
	gg.transform = Transform3D(firstpos.basis, firstpos.origin + firstpos.basis.z*(ngg*0.3) + firstpos.basis.x*(-ngg*0.1))
	ngg += 1
	var mat = gg.get_node("MeshInstance3D").get_surface_override_material(0)
	mat.albedo_texture = ImageTexture.create_from_image(img)
	add_child(gg)
