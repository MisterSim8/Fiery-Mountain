extends KinematicBody2D


# Declare member variables here. Examples:
var score = 15 # le nombre de points que la plateforme donne
var platformScored = false # true si le joueur a déjà eu les points pour avoir marché sur cette plateforme
var isLast = false #true s'il s'agit de la dernière plateforme
signal playerScored(platformScore,isLast) #signal envoyé au main quand le joueur entre sur la plateforme

const XMOUVEMENT_DELTA = 50 # le delta que la plateforme parcourt de chaque côté
const SPEED = 1 #la vitesse de mouvement

var current_delta = 0 # le mouvement que la plateforme a fait par rapport à son point d'origine
var estNeg = false # true si le mouvement en x est vers la gauche (négatif)
var velocity: Vector2

func _physics_process(delta):
	velocity = Vector2.ZERO
	
	if estNeg == false:
		velocity.x = SPEED
	else:
		velocity.x = -SPEED

	current_delta += velocity.x
	
	if current_delta <= -XMOUVEMENT_DELTA:
		estNeg = false
	
	if current_delta >= XMOUVEMENT_DELTA:
		estNeg = true
	
	move_and_collide(velocity)

func _on_zone_body_entered(body):
	if body.name == "player" and platformScored == false:
		platformScored = true
		print("signal called")
		emit_signal("playerScored",$".".score,isLast)
