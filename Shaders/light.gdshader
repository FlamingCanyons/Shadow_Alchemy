shader_type canvas_item;
render_mode world_vertex_coords;
// Light Info Vector
global uniform vec4 light_0;
global uniform vec4 light_1;
global uniform vec4 light_2;
global uniform vec4 light_3;
global uniform vec4 light_4;
global uniform vec4 light_5;
global uniform vec4 light_6;
global uniform vec4 light_7;
// Light Enum
global uniform int light_type_0;
global uniform int light_type_1;
global uniform int light_type_2;
global uniform int light_type_3;
global uniform int light_type_4;
global uniform int light_type_5;
global uniform int light_type_6;
global uniform int light_type_7;
varying vec2 vertpos;
void vertex() {	
	vertpos = (MODEL_MATRIX*vec4(VERTEX.x,VERTEX.y,0,0)).xy;
}

float sigmoid(float x,float scale){
	x = (x)*scale;
	return 1./(1.+exp(-x));
}

vec3 rgb2hsv(vec3 c){
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
vec3 hsv2rgb(vec3 c){
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	vec2 pos = (FRAGCOORD.xy*TEXTURE_PIXEL_SIZE+vertpos)/100.;
	vec4 lights[8] = {light_0,light_1,light_2,light_3,light_4,light_5,light_6,light_7};
	int  light_types[8] = {light_type_0,light_type_1,light_type_2,light_type_3,light_type_4,light_type_5,light_type_6,light_type_7};
	vec4 input_color = texture(TEXTURE,UV);
	float avg = (input_color.r + input_color.g + input_color.b) / 5.0;
	bool  in_light = false;
	int  in_soft_light = 0;
	float soft_light_value = 0.;
	for(int i = 0; i<8; i++){
		float loc_x = lights[i].x-pos.x;
		float loc_y = lights[i].y-pos.y;
		switch(light_types[i]){
			case 0: // Circle
				float range = sqrt(loc_x*loc_x + loc_y*loc_y);
				in_light      = in_light      || range<lights[i].z;
				if(range<(lights[i].z*1.2)){
					in_soft_light += 1;
					float buffer_zone  = (lights[i].z*1.2-lights[i].z);
					float buffer_range = range-lights[i].z;
					soft_light_value   += (buffer_zone-buffer_range)/buffer_zone;
				}
				break;
			case 1: // Triangle
				float tmp_loc_x = loc_x*cos(lights[i].w) + loc_y*sin(lights[i].w);
				float tmp_loc_y = loc_y*cos(lights[i].w) - loc_x*sin(lights[i].w); 
				in_light = in_light || (
					tmp_loc_x < lights[i].z 
					&& abs(tmp_loc_y) < abs(tmp_loc_x/3.+2.) 
					&& tmp_loc_x > 0.);
				bool _in_soft_light = (
					tmp_loc_x < lights[i].z*1.2 
					&& abs(tmp_loc_y) < abs(tmp_loc_x/3.+2.)*1.3 
					&& tmp_loc_x > -1.);
				if(_in_soft_light){
					in_soft_light += 1;
					float front_buffer_zone  = lights[i].z*1.2 - lights[i].z;
					float front_buffer_range = tmp_loc_x - lights[i].z;
					float side_buffer_zone   = abs(tmp_loc_x/3.+2.)*1.3 - abs(tmp_loc_x/3.+2.);
					float side_buffer_range  = abs(tmp_loc_y) - abs(tmp_loc_x/3.+2.);
					float side_weight  = (side_buffer_zone-side_buffer_range)/side_buffer_zone;
					float front_weight = (front_buffer_zone-front_buffer_range)/front_buffer_zone;
					if(side_weight > 1. || side_weight < 0.) soft_light_value += front_weight;
					else if(front_weight > 1. || front_weight < 0.) soft_light_value += side_weight;
					else soft_light_value += min(side_weight,front_weight);
				}
				break;
		}
	}
	if(in_light){
		vec3 hsv = rgb2hsv(input_color.xyz);
		hsv.z = sigmoid(hsv.z-.4,8.);
		input_color.xyz = hsv2rgb(hsv);
	}
	else if (in_soft_light >= 1){
		vec3 hsv = rgb2hsv(input_color.xyz);
		hsv.z = sigmoid(hsv.z-.4,8.);
		vec3 light_color = hsv2rgb(hsv);
		
		hsv = rgb2hsv(input_color.xyz);
		hsv.y = 0.0;
		hsv.z = sigmoid(hsv.z-.5,6.)*.5;
		vec3 dark_color = hsv2rgb(hsv);
		//input_color.w *= soft_light_value;
		soft_light_value = clamp(soft_light_value,0.,1.);
		input_color.xyz = light_color*soft_light_value + dark_color*(1.-soft_light_value);
		//input_color.w = soft_light_value;
	}
	else{
		vec3 hsv = rgb2hsv(input_color.xyz);
		hsv.y = 0.0;
		hsv.z = sigmoid(hsv.z-.5,6.)*.5;
		input_color.xyz = hsv2rgb(hsv);
		//input_color.r = avg;
		//input_color.g = avg;
		//input_color.b = avg;
	}
	vec2 size = TEXTURE_PIXEL_SIZE;
	COLOR = vec4(input_color.r,input_color.g,input_color.b,input_color.a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
