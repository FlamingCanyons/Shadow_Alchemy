extends CollisionPolygon2D


var Position = Vector2(0,0)
var time_start
var light_name = ""
var light_type_name = ""
var light_type = 0 
var light_size = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	time_start = Time.get_ticks_msec( )
	Position = self.position
	var id = Globals.light_counter
	Globals.light_counter += 1
	light_name      = "light_" + str(id)
	light_type_name = "light_type_" + str(id)
	light_type		= 1 #self.get_meta("light_type")
	var length = abs(self.polygon[0].x - self.polygon[1].x)*get_parent().scale.x
	light_size      = Vector2(length,0)# self.get_meta("light_size")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var elapled_time = (Time.get_ticks_msec() - time_start)/1000.0
	light_size.y = elapled_time
	#light_size.y = get_parent().rotation
	RenderingServer.global_shader_parameter_set(light_name,
		  Vector4(get_parent().position.x,get_parent().position.y,light_size.x,light_size.y))
	RenderingServer.global_shader_parameter_set(light_type_name, int(light_type))
	
	
	#self.position.x = Position.x + sin(elapled_time)*20.0;
	#self.position.y = Position.y + cos(elapled_time)*20.0;
	#if(light_type == 1):
		#light_size.y = elapled_time*3
		#var light_tmp = light_size;
		#light_size.x = light_tmp.x * cos(elapled_time*3) + light_tmp.y * sin(elapled_time*3)
		#light_size.y = light_tmp.y * cos(elapled_time*3) - light_tmp.x * sin(elapled_time*3)
	
