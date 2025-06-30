extends "res://addons/gd-plug/plug.gd"

# from clean clone run `godot4 --headless -s plug.gd update debug`

func _plugging():

	plug("GodotVR/godot-xr-tools", {"commit": "c5c74338f88d393ee0724becf206f7d8dde744e0"})  # v4.3.0
	#plug("GodotVR/godot-xr-tools", {"commit": "4d53140015ba5feb6f6ec07873f050311ffe1fdc"})  # v4.4.1 (has a rumble manager problem)

	plug("bnjmntmm/godot-exoplayer")
	plug("goatchurchprime/godot-mqtt")
	plug("TheWalruzz/godot-promise")
	plug("Nitwel/Rdot")
	plug("Godot-Dojo/Godot-XR-AH", {"include":["addons/xr-autohandtracker"]})
	plug("Cafezinhu/godot-vr-simulator", {"commit": "5bedbbacf6fe40af10e0bfea99487c84387b19f3"})

	# We cannot use the primary version of CDT because nitwel's version had to be additionally compiled for android
	# I would like to do it like the following, but plug.gd doesn't play nice with git-lfs and throws smudge errors 
	#plug("Nitwel/Immersive-Home", {"include":["app/addons/godot-cdt"]})

	# so we need to use the stashedaddons technique with a normal git repo
	var stashedaddons = ["addons/godot-cdt"]
	plug("goatchurchprime/paraviewgodot", {"branch":"stashedaddons", "include":stashedaddons})

	# The godotopenxrvendorsaddon should be downloaded from the asset-store as it is part of the hardware platform, 
	# in much the same way we need to install the Android templates and Android build tools directory tbrough the editor UI

