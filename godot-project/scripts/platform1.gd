extends StaticBody2D

const TIMER_DELAY = 1.5 # Le délai du timer



func _ready():

	$Timer.set_one_shot(true)
	$Timer.set_autostart(false)
	$Timer.set_wait_time(TIMER_DELAY)
	
	#connections
	$Timer.connect("timeout",self,"_on_timer_timeout") 

func _process(delta):
	pass
		


func _on_timer_timeout():
	$".".queue_free()
	print("fin plateforme")

func _on_zone_body_entered(body):
	print(str(body))
	if body.name == "player":
		$Timer.start()
		print("timer start")

			
