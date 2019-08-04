extends Control	

func _on_player_update_item_name(show, item_label):
	#print("HITT")
	visible = show
	if show:
		if item_label:
			$MarginContainer/Label.text = item_label
		else:
			$MarginContainer/Label.text = "nada"
	else:
		$MarginContainer/Label.text = ""


func _on_player_rumble(show, item_label):
	print("HEJOO")
	if show:
		#$CenterContainer/Label.text = "NEEEE"
		$CenterContainer/Label.text = item_label
	else:
		$CenterContainer/Label.text = "FALSE"
