extends Node

#SCENES
onready var sceneEau = preload("res://scenes/water.tscn")
onready var scenePlatformUn = preload("res://scenes/platform1.tscn")
onready var scenePlatformDeux = preload("res://scenes/platform2.tscn")
onready var scenePlatformTrois = preload("res://scenes/platform3.tscn")
#FIN SCENES

#VAR PLATEFORMES
const platformYGap = 50 # la constante de distance en y entre les plateformes
const platformXMinOffset = 30 # la constante de distance minimale en x entre chaque paire de plateformes
const platformXMaxOffset = 50 # la constante de distance minimale en x entre chaque paire de plateformes
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

#VAR JOUEUR

#FIN JOUEUR

# Called when the node enters the scene tree for the first time.
func _ready():
	initWater()

func _process(delta):
	majUI()


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
	print("scored!")
	scoreJoueur = scoreJoueur + 1
	resetPlayer()
##FIN CALLBACKS


func majUI():
	get_node("player/GUI/HBoxScore/scoreData").text = str(scoreJoueur)
