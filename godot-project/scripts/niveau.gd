extends Node2D


onready var sceneEau = preload("res://scenes/water.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	initWater() # Replace with function body.


func raiseWater():
	pass

func initWater():
	
	#récupère le staticBody qui contient l'eau
	var bodyEau = $".".get_node("water")
	
	#récupère la distance que l'eau doit couvrir
	var groundSize = ($".".get_node("background/groundArea/area").get_shape().extents.x) * 21
	
	#récupère la profondeur que l'eau doit couvrir
	var depth = ($".".get_node("background/groundArea/area").get_shape().extents.y) * 4
	
	#récupère le nombre de sprites d'eau requis en x
	var instanceSizeEauX = sceneEau.instance()
	var spriteSizeEauX = instanceSizeEauX.get_node("top").get_sprite_frames().get_frame("default",0).get_size().x
	var numSpriteRequisX = ceil(groundSize/spriteSizeEauX)
	
	
	#récupère là ou l'eau doit commencer à se dessiner sur l'axe des x
	var yOffset = 20
	var debutEauX = - floor(groundSize/3)
	
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
	
		
		

