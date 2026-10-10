shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	//vec2 uv = UV;
	////uv.x = step( UV.x - progress, 0.8);
	//COLOR = vec4(uv.x, 0.0,0.0,1.0);
	float p = UV.x;
    COLOR = vec4(p, 0.0, 0.0, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
