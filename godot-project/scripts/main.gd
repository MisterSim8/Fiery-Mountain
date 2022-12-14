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


# Called when the node enters the scene tree for the first time.
func _ready():
	initWater()

func _process(delta):
	majUI()
	if Input.is_action_just_pressed("test"):
		addPlatform(1)


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

		if nouveauPlatformNum == 1:
			nouveauPlatformInstance = scenePlatformUn.instance()
		elif nouveauPlatformNum == 2:
			nouveauPlatformInstance = scenePlatformDeux.instance()
		elif nouveauPlatformNum == 3:
			nouveauPlatformInstance = scenePlatformTrois.instance()
		else:
			nouveauPlatformInstance = scenePlatformUn.instance()

		#on détermine le type de la nouvelle plateforme
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var nouveauPlatformWidth = nouveauPlatformInstance.get_node("zone/area").get_shape().extents.x
		var distanceX = rng.randi_range(platformXMinOffset,platformXMaxOffset) + lastPlatformWidth
		print("width: "+str(nouveauPlatformWidth))
		print("distance X initiale: "+str(distanceX))


		if rng.randi_range(1,2) == 1:
			distanceX = -distanceX

		if (lastPlatformX + distanceX) < (colliderLeft.position.x + colliderLeft.get_shape().extents.x):
			distanceX = -distanceX
			print("left true")
		if (lastPlatformX + lastPlatformWidth + distanceX + nouveauPlatformWidth) > colliderRight.position.x:
			print("right true")
			distanceX = -distanceX

		distanceX = lastPlatform.position.x + lastPlatformWidth +distanceX
		var nouveauY = lastPlatform.position.y - platformYGap

#		#on place la plateforme
		nouveauPlatformInstance.position.x = distanceX
		nouveauPlatformInstance.position.y = nouveauY
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

#CALLBACKS
func _on_star_body_entered(body):
	scoreJoueur = scoreJoueur + 1
	#resetPlayer()
##FIN CALLBACKS


func majUI():
	get_node("player/GUI/HBoxScore/scoreData").text = str(scoreJoueur)
