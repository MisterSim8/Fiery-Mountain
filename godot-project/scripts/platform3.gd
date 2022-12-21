extends StaticBody2D


var score = 10 # le nombre de points que la plateforme donne
var platformScored = false # true si le joueur a déjà eu les points pour avoir marché sur cette plateforme
var isLast = false #true s'il s'agit de la dernière plateforme
signal playerScored(platformScore,isLast) #signal envoyé au main quand le joueur entre sur la plateforme

func _on_zone_body_entered(body):
	if body.name == "player" and platformScored == false:
		platformScored = true
		print("signal called")
		emit_signal("playerScored",$".".score,isLast)
