extends Node

const light_total = 8
var light_counter = 0

#
## Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.global_shader_parameter_set("light_0", Vector4(-999.0,-999.0,0.,0.))
	RenderingServer.global_shader_parameter_set("light_1", Vector4(-999.0,-999.0,0.,0.))
	RenderingServer.global_shader_parameter_set("light_2", Vector4(-999.0,-999.0,0.,0.))
	RenderingServer.global_shader_parameter_set("light_3", Vector4(-999.0,-999.0,0.,0.))
	RenderingServer.global_shader_parameter_set("light_4", Vector4(-999.0,-999.0,0.,0.))
	RenderingServer.global_shader_parameter_set("light_5", Vector4(-999.0,-999.0,0.,0.))
	RenderingServer.global_shader_parameter_set("light_6", Vector4(-999.0,-999.0,0.,0.))
	RenderingServer.global_shader_parameter_set("light_7", Vector4(-999.0,-999.0,0.,0.))
	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
