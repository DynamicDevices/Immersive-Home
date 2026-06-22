extends "res://addons/gd-plug/plug.gd"

# from inside clean clone (in the app directory) run:
#   godot4 --import
#   godot4 --headless --xr-mode off -s plug.gd update debug
# Wait till it says Execution finished, then do Ctrl-C

func _plugging():

	#plug("GodotVR/godot-xr-tools", {"commit": "4d53140015ba5feb6f6ec07873f050311ffe1fdc"})  # v4.4.1 (has a rumble manager problem)
	#plug("GodotVR/godot-xr-tools", {"commit": "c5c74338f88d393ee0724becf206f7d8dde744e0"})  # v4.3.0
	#plug("GodotVR/godot-xr-tools", {"commit": "aecfc894d9581cf4ca6df7fdd09098040497aa8e"})  # v4.5.0
	plug("GodotVR/godot-xr-tools", {"commit": "a3826dd2496a7935767519d6b34fbe9e8748cf85"})  # bleeding edge

	# the following doesn't work as wanted due to https://github.com/imjp94/gd-plug/issues/47
	#plug("bnjmntmm/godot-exoplayer", {"install_root": "addons/godot_exoplayer", "include":["plugin/demo/addons/godot_exoplayer"]})

	plug("goatchurchprime/godot-mqtt")
	plug("TheWalruzz/godot-promise")
	#plug("Nitwel/Rdot")  # copied in so we can debug one line
	plug("Godot-Dojo/Godot-XR-AH", {"include":["addons/xr-autohandtracker"], "commit":"2b13e0d2800186f927ecce980bb4d04114600199"})  # godot 4.6 version

	plug("Cafezinhu/godot-vr-simulator", {"commit": "5bedbbacf6fe40af10e0bfea99487c84387b19f3"})

	# We cannot use the primary version of CDT because nitwel's version had to be additionally compiled for android
	# I would like to do it like the following, but plug.gd doesn't play nice with git-lfs and throws smudge errors 
	#plug("Nitwel/Immersive-Home", {"include":["app/addons/godot-cdt"]})

	# we need to use the stashedaddons technique with a normal git repo for cdt and exoplayer
	var stashedaddons = ["addons/godot-cdt", "addons/godot_exoplayer"]
	plug("goatchurchprime/paraviewgodot", {"branch":"stashedaddons", "include":stashedaddons})

	# The godotopenxrvendorsaddon should be downloaded from the asset-store as it is part of the hardware platform, 
	# in much the same way we need to install the Android templates and Android build tools directory tbrough the editor UI
