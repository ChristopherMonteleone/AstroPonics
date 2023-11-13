# how to use: (ASSUMING CALLING FROM EXTERNAL NODE !
# global var t
#_ready():
#	t = RE.new()
#	add_child(t)
#func _process(delta):
#	t.launcher(20)

class_name RE 

extends Label # changed from Node to Label now to try to show text that RE started
# had to make a child node of RE label to show animated text for now ... ^ 
var spawnerObject; # RE launcher one for the random events it generates.
var currRunning = false; # bool that says if it is running an event 
# GENERATION OF NODES TO SCENE 
var rng = RandomNumberGenerator.new()
var timerStarted = false 
var overlay : ShaderMaterial 
var overlay_node
var camera_node
var animate_text

func _init(): # CONSTRUCTOR, built before child nodes 
	pass
	
static func build():
	pass 

# Called when the node enters the scene tree for the first time. child nodes come back ready() 
func _ready():
	# OVERLAY NODE
	overlay_node = get_node("/root/Main2D/Overlay")
	overlay_node.set_visible(true)
	overlay = overlay_node.get_material()
	# CAMERA NODE
	camera_node = get_node("/root/Main2D/Camera2D")
	animate_text = get_node("/root/Main2D/RandomEvents/AnimateText")
	pass  

func get_curr():
	return currRunning; 
	
func alarm_blare():
	# set animate text visiblity
	var x = get_curr()
	if (x):
		animate_text.set("fade", true)
	else:
		animate_text.set("fade", false)	
	
func cam_effect(): # fix later ... 
	camera_node.camera_effect()

func activateRE(): # SUCCESS! now call a random event. 
	currRunning = true 
	alarm_blare()
	if !timerStarted: # or $Alarm_Timer.is_stopped() 
		timerStarted = true 
	spawnerObject = rng.randi_range(1,2) 
	match spawnerObject:
		1: # DISTORT
			push_warning("distortion")
			overlay.set_shader_parameter("onoff", 1.0)
			await get_tree().create_timer(5).timeout # wait 5 secs 
			overlay.set_shader_parameter("onoff", 0.0)
		2: # SHAKE SCREEN
			push_warning("screen shake") 
			camera_node.set("shake", true)
			#cam_effect()
			await get_tree().create_timer(5).timeout # wait 5 secs 
			camera_node.set("shake", false)
		# 3: # PH IMBALANCE
		#5: # crt 
	currRunning = false # reset 
	alarm_blare()
	timerStarted = false
	
func launcher(rndNum): 
	rng.randomize() 
	var myRndNum = rng.randf_range(0, 1); # 0 to 100% chance
	if (myRndNum <= rndNum):
		push_warning("succesful hit!")
		activateRE(); # ALARM BLARES !!
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): 
	pass
