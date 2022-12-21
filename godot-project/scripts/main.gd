extends Node

#SCENES
onready var sceneEau = preload("res://scenes/water.tscn")
onready var scenePlatformUn = preload("res://scenes/platform1.tscn")
onready var scenePlatformDeux = preload("res://scenes/platform2.tscn")
onready var scenePlatformTrois = preload("res://scenes/platform3.tscn")
#FIN SCENES

#VAR PLATEFORMES
const platformYGap = 135 # la constante de distance en y entre les plateformes
const platformXMinOffset = 80 # la constante de distance minimale en x entre chaque paire de plateformes
const platformXMaxOffset = 85 # la constante de distance minimale en x entre chaque paire de plateformes
onready var colliderLeft = get_node("background/colliderleft")
onready var colliderRight = get_node("background/colliderright")
#FIN VAR PLATEFORMES

#VAR JOUEUR
var scoreJoueur = 0
var pvJoueur = 3
var positionInitialeJoueurX = 323
var positionInitialeJoueurY = 508
#FIN VAR JOUEUR

# VAR EAU
#récupère le staticBody qui contient l'eau
var bodyEau = null
#récupère la distance que l'eau doit couvrir
var groundSize = null
#récupère la profondeur que l'eau doit couvrir
var depth = null
#récupère le nombre de sprites d'eau requis en x
var spriteSizeEauX = null
var numSpriteRequisX = null
#récupère là ou l'eau doit commencer à se dessiner sur l'axe des x
var yOffset = 0
var debutEauX = 0
#FIN VAR EAU

#VAR JEU
var tempsEau = 0.0
var interValEau = 1
var raiseEau = 10
#FIN VAR JEU



func _ready():
	initWater()

func _process(delta):
	majUI()
	#on évalue la condition de mort
	if pvJoueur <=0:
		die()
	if Input.is_action_just_pressed("test"):
		addPlatform(1)
	
func _physics_process(delta):
	#gestion eau
	tempsEau += delta
	if tempsEau >= interValEau:
		#raiseWater(raiseEau)
		tempsEau = 0


func addPlatform(platformAmount):
	for i in range(platformAmount):
		#on agrandit la texture de background vers le haut
		$textureLoop.rect_size.y+= platformYGap *3
		$textureLoop.rect_position.y-=platformYGap*3
		
		# on agrandit les barrières invisibles à gauche et à droite
		colliderLeft.get_shape().extents.y +=platformYGap * 3
		colliderRight.get_shape().extents.y += platformYGap * 3

		#on trouve la derniere plateforme placée
		var lastPlatform = null
		var lastPlatformX = 0
		var lastPlatformWidth = 0

		for j in range(get_child_count()):
			if get_child(j).is_in_group("platform") == true:
				lastPlatform = get_child(j)

		lastPlatformX = lastPlatform.position.x
		lastPlatformWidth = lastPlatform.get_node("zone/area").get_shape().extents.x

		#on détermine le type de la nouvelle plateforme
		randomize()
		var nouveauPlatformNum = randi() % 4 + 1
		var nouveauPlatformInstance = null
		var nouveauPlatformWidth = null

		if nouveauPlatformNum == 1:
			nouveauPlatformInstance = scenePlatformUn.instance()
		elif nouveauPlatformNum == 2:
			nouveauPlatformInstance = scenePlatformDeux.instance()
		elif nouveauPlatformNum == 3:
			nouveauPlatformInstance = scenePlatformTrois.instance()
		else:
			nouveauPlatformInstance = scenePlatformUn.instance()
	
		#on détermine la dimension de la nouvelle plateforme
		nouveauPlatformWidth = nouveauPlatformInstance.get_node("zone/area").get_shape().extents.x

		#on détermine la direction de la nouvelle plateforme par rapport à la dernière
		var estGauche = false # True si la nouvlle plateforme est à gauche de la dernière

		if randi() % 3 + 1 == 1:
			estGauche = true
			print("est gauche")
		
		#on détermine la distance en X de la nouvelle plateforme plar rapport à la dernière
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var distanceX = null
		distanceX = rng.randi_range(platformXMinOffset,platformXMaxOffset)
		if estGauche == true:
			distanceX = -distanceX
			if abs(distanceX) <= nouveauPlatformWidth:
				distanceX = distanceX-(lastPlatformWidth*0.5) # on s'assure que, depuis la dernière plateforme, on puisse toujours monter sur la nouvelle.

		#on vérifie que sa position ne dépasse pas le bodures de gauche et de droite
		if (lastPlatformX + distanceX) < (colliderLeft.position.x + colliderLeft.get_shape().extents.x):
			distanceX = -distanceX
			print("left true")
		if (lastPlatformX + distanceX + nouveauPlatformWidth) > colliderRight.position.x:
			print("right true")
			distanceX = -distanceX

		print("Distance X finale: "+str(distanceX))

		#on place la plateforme
		nouveauPlatformInstance.position.x = lastPlatform.position.x + distanceX
		nouveauPlatformInstance.position.y = lastPlatform.position.y - platformYGap
		add_child(nouveauPlatformInstance)

func raiseWater(raiseHeight):
	for i in range(bodyEau.get_child_count()):
		if bodyEau.get_child(i).is_in_group("eau") == true:
			bodyEau.get_child(i).position.y -= raiseHeight

	$".".get_node("water/baseTexture").rect_size.x +=raiseHeight
	$".".get_node("water/baseTexture").rect_position.y -= raiseHeight

	$".".get_node("water/collider").position.y -= raiseHeight

func initWater():
	#on assigne les valeurs aux variables de l'eau
	bodyEau = $".".get_node("water")
	groundSize = ($".".get_node("background/groundArea/area").get_shape().extents.x) * 9
	depth = ($".".get_node("background/groundArea/area").get_shape().extents.y) * 4

	var instanceSizeEauX = sceneEau.instance()
	spriteSizeEauX = instanceSizeEauX.get_node("top").get_sprite_frames().get_frame("default",0).get_size().x
	numSpriteRequisX = ceil(groundSize/spriteSizeEauX)

	debutEauX = - floor(groundSize/3)
	yOffset = 20

	
	#place les sprites d'eau en surface
	for i in range(numSpriteRequisX):
		var instanceEauX = sceneEau.instance()
		instanceEauX.position.x = debutEauX + (spriteSizeEauX * i-1)
		instanceEauX.position.y = yOffset
		bodyEau.add_child(instanceEauX)

	#assure que le fond de l'eau couvre l'espace requis
	$".".get_node("water/baseTexture").rect_position.x = debutEauX
	$".".get_node("water/baseTexture").rect_position.y = yOffset+5
	$".".get_node("water/baseTexture").rect_size.x = groundSize
	$".".get_node("water/baseTexture").rect_size.y = depth
	
	#ajuste le collider de l'eau
	$".".get_node("water/collider").position.y+=yOffset

func resetWater():

	for i in range(bodyEau.get_child_count()):
		if bodyEau.get_child(i).is_in_group("eau") == true:
			bodyEau.get_child(i).position.y = yOffset
	
	$".".get_node("water/baseTexture").rect_position.x = debutEauX
	$".".get_node("water/baseTexture").rect_position.y = yOffset+5
	$".".get_node("water/baseTexture").rect_size.x = groundSize
	$".".get_node("water/baseTexture").rect_size.y = depth
	
	#ré-ajustement collision de l'eau
	$".".get_node("water/collider").position.y = $".".get_node("water/collider").get_shape().extents.y+yOffset

func resetPlayer():
	$player.position.x = positionInitialeJoueurX
	$player.position.y = positionInitialeJoueurY

func die():
	get_tree().change_scene("res://scenes/menu.tscn")#retour au menu

#CALLBACKS
func _on_star_body_entered(body):
	scoreJoueur = scoreJoueur + 1
	#resetPlayer()
func _on_water_body_entered(body):
	if body.name == "player":
		pvJoueur = pvJoueur - 1
		resetWater()
		resetPlayer()
##FIN CALLBACKS


func majUI():
	get_node("player/GUI/HBoxScore/scoreData").text = str(scoreJoueur)

	if pvJoueur == 2:
		$player/GUI/heart3.visible = false
	if pvJoueur == 1:
		$player/GUI/heart2.visible = false
	if pvJoueur == 0:
		$player/GUI/heart.visible = false



