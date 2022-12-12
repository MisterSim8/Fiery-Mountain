extends KinematicBody2D

var velocity : Vector2

export var vitesse_max : int = 1000
export var gravity : float = 55
export var vitesse_tombee_max: int = 2000 # vitesse maximale à laquelle le joueur peut tomber lorsqu'il est soumis à la gravité
export var vitesse_lerp: float = 0.2 # la constante de décélération de l'interpolation linéaire
export var force_saut : int = 1600
export var acceleration : int = 50
export var jump_buffer_time : int  = 15 # le temps que le joueur a pour pouvoir sauter sans être complétement atteri au sol. S'il pèse dans ce délai sur la touche de saut, il sautera immédiatement à nouveau une fois rendu au sol.
export var coyote_time : int = 15 # le temps que le joueur a quand il tombe d'une plateforme pour pouvoir peser sur la touche espace et pouvoir sauter. 

var jump_buffer_counter : int = 0 # mesurer le délai pour le "jump_buffer" 
var coyote_counter : int = 0 #mesurer le délai pour le "coyote_time"

func _physics_process(_delta):
	var movingX = false # true si le joueur est en train de bouger sur l'axe des x
	if is_on_floor():
		coyote_counter = coyote_time

	if not is_on_floor():
		if coyote_counter > 0:
			coyote_counter -= 1
		
		velocity.y += gravity
		if velocity.y > vitesse_tombee_max:
			velocity.y = vitesse_tombee_max

	if Input.is_action_pressed("right"):
		velocity.x += acceleration
		anim_droite() 
		movingX = true

	elif Input.is_action_pressed("left"):
		velocity.x -= acceleration
		anim_gauche()
		movingX = true

	else:
		velocity.x = lerp(velocity.x,0,0.2) # ajustment du vecteur x pour une décélération graduelle du joueur
	
	velocity.x = clamp(velocity.x, -vitesse_max, vitesse_max) # on assure que le joueur ne peut pas accélérer ou décélérer en dehors des limites de vitesse
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = jump_buffer_time
		anim_saut()
		
	
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1

	if jump_buffer_counter > 0 and coyote_counter > 0:
		velocity.y = -force_saut
		jump_buffer_counter = 0
		coyote_counter = 0
	
	if Input.is_action_just_released("jump"):
		if velocity.y < 0:
			velocity.y += 400
	
	velocity = move_and_slide(velocity, Vector2.UP)

	if movingX == false and is_on_floor(): # si on ne bouge pas et on ne saute pas,
		anim_rest()

#fonction qui lance l'animation de course vers la droite
func anim_droite():
		$AnimatedSprite.play("default-walk-right")

#fonction qui lance l'animation de course vers la gauche
func anim_gauche():
		$AnimatedSprite.play("default-walk-left")

#fonction qui gère l'animation de saut
func anim_saut():
		$AnimatedSprite.play("default-jump")

#fonction qui gère l'animation de mort
func anim_mort():
		$AnimatedSprite.play("default-die")

func anim_rest():
	$AnimatedSprite.play("default-rest")
