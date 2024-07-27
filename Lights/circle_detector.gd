extends CollisionShape2D


var Position = Vector2(0,0)
var time_start
var light_name = ""
var light_type_name = ""
var light_type = 0 
var light_size = Vector2(10.,0.)
# Called when the node enters the scene tree for the first time.
func _ready():
	time_start = Time.get_ticks_msec( )
	Position = self.position
	var id = Globals.light_counter
	Globals.light_counter += 1
	light_name      = "light_" + str(id)
	light_type_name = "light_type_" + str(id) #self.get_meta("light_id")
	light_type		= 0 #self.get_meta("light_type")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	light_size.x = float(self.shape.get_rect().size.x/2)*get_parent().scale.x
	RenderingServer.global_shader_parameter_set(light_name,
		  Vector4(get_parent().position.x,get_parent().position.y,light_size.x,light_size.y))
	RenderingServer.global_shader_parameter_set(light_type_name, int(light_type))
	
	var elapled_time = (Time.get_ticks_msec() - time_start)/1000.0
	self.position.x = Position.x + sin(elapled_time)*20.0;
	self.position.y = Position.y + cos(elapled_time)*20.0;
