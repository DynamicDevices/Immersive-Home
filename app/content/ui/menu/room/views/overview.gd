extends Node3D

func _on_walls_button_on_toggled(active):
	App.house.blueborder_alignment(active)
	$ApplyAlignment.disabled = not active
	$MoveAlignment.disabled = not active

func _on_move_alignment_on_button_down():
	App.house.move_alignment()

func _on_apply_alignment_on_button_down():
	App.house.apply_alignment()

func D_on_apply_alignment_on_button_down():
	Store.house.doors = []
	App.house.update_house()
