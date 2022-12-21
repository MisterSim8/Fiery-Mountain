extends KinematicBody2D


# Declare member variables here. Examples:
const XMOUVEMENT_DELTA = 50 # le delta que la plateforme parcourt de chaque côté
const SPEED = 1 #la vitesse de mouvement

var current_delta = 0 # le mouvement que la plateforme a fait par rapport à son point d'origine
var estNeg = false # true si le mouvement en x est vers la gauche (négatif)
var velocity: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
		
