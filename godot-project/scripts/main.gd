extends Node

const platformYGap = 50 # la constante de distance en y entre les plateformes
const platformXMinOffset = 30 # la constante de distance minimale en x entre chaque paire de plateformes
const platformXMaxOffset = 50 # la constante de distance minimale en x entre chaque paire de plateformes

#SCENES
onready var scenePlatformUn = preload("res://scenes/platform1.tscn")
onready var scenePlatformDeux = preload("res://scenes/platform2.tscn")
onready var scenePlatformTrois = preload("res://scenes/platform3.tscn")
#FIN SCENES


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(delta):
	majUI()

func majUI():
	pass

func spawnStructures():
	pass
