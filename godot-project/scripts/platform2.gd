extends StaticBody2D

func _on_zone_body_entered(body):
	if body.name == "player":
		body.toggleGlisse()
	

			


func _on_zone_body_exited(body):
	if body.name == "player":
		body.toggleGlisse()
		body
