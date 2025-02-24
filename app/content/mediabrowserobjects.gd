extends Node3D

# see https://developers.home-assistant.io/docs/api/websocket/
# trying to get the media browser data from here, so we can download images
# direct from the HASS as an input for managing images
# https://mr5g.dynamicdevices.co.uk/media-browser/browser/app%2Cmedia-source%3A%2F%2Fimage_upload

var firstpos = null
var ngg = 1
func _ready():
	firstpos = get_child(0).transform
	#get_child(0).queue_free()

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

func fetch_mediaimages():
	var serverbase = "https://mr5g.dynamicdevices.co.uk"
	#var uurl = serverbase+"/api/image/serve/454236fa719199fdb41b8f4110a19e13/original?authSig=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI3ZThiOGE3M2I0Nzc0NGE4YmJmNDA1MGYxOTg5NGRkNyIsInBhdGgiOiIvYXBpL2ltYWdlL3NlcnZlLzQ1NDIzNmZhNzE5MTk5ZmRiNDFiOGY0MTEwYTE5ZTEzL29yaWdpbmFsIiwicGFyYW1zIjpbXSwiaWF0IjoxNzQwMjYzODk0LCJleHAiOjE3NDAzNTAyOTR9.dxmOP63zs_qfabr7tl2K_feEKCPzXctJhSg65ncdlKc"
	#print(uurl)
	#fetchurldata(uurl)
	#return
	
	if not HomeApi.has_connected():
		return
	var jgetpanels = { "type": "get_panels" }
	var jmediacontent = { "type": "media_source/browse_media", "media_content_id":"media-source://media_source" }
	var jmediaupload = { "type": "media_source/browse_media", "media_content_id":"media-source://image_upload"  }
	var response = await HomeApi.api.connection.send_request_packet(jmediacontent)
	#var response = await HomeApi.api.connection.send_request_packet(jmediaupload)
	if not (response.payload.get("success") and response.payload.type == "result"):
		print("fetch_mediaimages failed")
		return
	var result = response.payload.result
	#print(result)
	var images = [ ]
	for c in result.children:
		if c.media_class == "image":
			images.append(c.media_content_id)

	var imageurls = [ ]
	for ci in images:
		var jmediaresolve = {"type":"media_source/resolve_media","media_content_id":ci}
		var response2 = await HomeApi.api.connection.send_request_packet(jmediaresolve)
		if response2.payload.get("success") and response2.payload.get("type") == "result":
			var url = response2.payload.result.url
			var mimetype = response2.payload.result.mime_type
			imageurls.append(serverbase+url)

	imageurls.reverse()
	for imageurl in imageurls:
		await fetchurldata(imageurl)
