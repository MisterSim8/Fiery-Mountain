extends KinematicBody2D


const GRAVITY = 700
const SPEED = 5
const JUMP_SPEED = 125
var velocity = Vector2(0,0)




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity = Vector2(0,0) #nouveau vecteur sur l'axe des x

	velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("jump"):
		velocity.y -= JUMP_SPEED
	if Input.is_action_pressed("right"):
		velocity.x += SPEED 
	if Input.is_action_pressed("left"):
		velocity.x -= SPEED
	velocity.normalized()
	move_and_collide(velocity)
	

func animate(delta):
	pass

