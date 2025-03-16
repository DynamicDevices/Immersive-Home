extends Node3D

func setvisibility(visibility):
	visible = visibility
	$NextButton.disabled = not visibility
